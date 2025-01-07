import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sql_lite/database/db_helper.dart';
import 'package:sql_lite/bloc/home_screen/home_event.dart';
import 'package:sql_lite/bloc/home_screen/home_state.dart';

class HomeBloc extends Bloc<HomeEvents, HomeState> {
  HomeBloc() : super(PictureLoading()) {
    on<LoadPictures>(_loadPictures);
    on<SavePicture>(_savePicture);
    on<DeletePicture>(_deletePicture);
  }

  DBHelper helper = DBHelper.instance;

  Future<void> _loadPictures(
      LoadPictures event, Emitter<HomeState> emit) async {
    emit(PictureLoading());
    await helper.getAllPictures().then((value) {
      emit(PictureLoaded(pictures: value));
    }).onError(
      (error, stackTrace) {
        emit(PictureLoadingError(message: error.toString()));
      },
    );
  }

  Future<void> _savePicture(SavePicture event, Emitter<HomeState> emit) async {
    emit(PictureSaving());
    await helper.addImage(event.picture).then((value) async {
      emit(PictureLoading());
      await helper.getAllPictures().then((value) {
        emit(PictureLoaded(pictures: value));
      }).onError(
        (error, stackTrace) {
          emit(PictureLoadingError(message: error.toString()));
        },
      );
    }).onError(
      (error, stackTrace) {
        emit(PictureDeleteError(message: error.toString()));
      },
    );
  }

  Future<void> _deletePicture(
      DeletePicture event, Emitter<HomeState> emit) async {
    // emit(PictureLoading());
    await helper.delete(event.id).then((value) async {
      emit(PictureLoading());
      await helper.getAllPictures().then((value) {
        emit(PictureLoaded(pictures: value));
      }).onError(
        (error, stackTrace) {
          emit(PictureLoadingError(message: error.toString()));
        },
      );
    }).onError(
      (error, stackTrace) {
        emit(PictureDeleteError(message: error.toString()));
      },
    );
  }
}
