import 'dart:io';
import 'dart:developer';
import 'package:sql_lite/models/picture.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sql_lite/database/db_helper.dart';
import 'package:sql_lite/bloc/image_picker/image_event.dart';
import 'package:sql_lite/bloc/image_picker/image_state.dart';

class ImageBloc extends Bloc<ImageEvent, ImageState> {
  ImageBloc() : super(ImagePickerInitialState()) {
    on<PickImageFromGalleryEvent>(_pickImageFromGallery);
    on<PickImageFromCameraEvent>(_pickImageFromCamera);
    on<SaveImageEvent>(_saveImage);
    on<UpdateImageEvent>(_updateImage);
  }
  ImagePicker picker = ImagePicker();

  _pickImageFromGallery(
      PickImageFromGalleryEvent event, Emitter<ImageState> emit) async {
    try {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        emit(ImagePickedState(
            imageString: File(image.path), title: "Gallery Image"));
      }
    } catch (e) {
      emit(ImagePickedErrorState(
          message: "Error occured while picking image from gallery"));
    }
  }

  _pickImageFromCamera(
      PickImageFromCameraEvent event, Emitter<ImageState> emit) async {
    try {
      final XFile? image = await picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        emit(ImagePickedState(
            imageString: File(image.path), title: "Gallery Camera"));
      }
    } catch (e) {
      emit(ImagePickedErrorState(
          message: "Error occured while picking image from camera"));
    }
  }

  _saveImage(SaveImageEvent event, Emitter<ImageState> emit) async {
    try {
      final picture = await DBHelper.instance.addImage(Picture(
          id: DateTime.now().microsecond,
          title: event.title,
          picture: event.imageBytes));
      emit(ImageSavedState(picture: picture));
      log(">>> image saved");
    } catch (e) {
      emit(ImagePickedErrorState(message: "Failed to save image"));
      log(">>> ${e.toString()}");
    }
  }

  _updateImage(UpdateImageEvent event, Emitter<ImageState> emit) async {
    try {
      final picture = await DBHelper.instance.update(event.id,
          Picture(id: event.id, title: event.title, picture: event.imageBytes));
      emit(ImageSavedState(picture: picture));
      log(">>> image saved");
    } catch (e) {
      emit(ImagePickedErrorState(message: "Failed to save image"));
      log(">>> ${e.toString()}");
    }
  }
}
