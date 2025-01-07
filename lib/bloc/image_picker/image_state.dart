import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:sql_lite/models/picture.dart';

abstract class ImageState extends Equatable {
  @override
  List<Object> get props => [];
}

class ImagePickerInitialState extends ImageState {}

class ImagePickedState extends ImageState {
  final File imageString;
  final String title;

  ImagePickedState({required this.imageString, required this.title});
}

class ImagePickedErrorState extends ImageState {
  final String message;

  ImagePickedErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

class ImageSavedState extends ImageState {
  final Picture picture;

  ImageSavedState({required this.picture});
}
