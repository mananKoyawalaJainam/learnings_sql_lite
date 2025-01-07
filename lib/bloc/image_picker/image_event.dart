import 'dart:typed_data';
import 'package:equatable/equatable.dart';

abstract class ImageEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class PickImageFromGalleryEvent extends ImageEvent {}

class PickImageFromCameraEvent extends ImageEvent {}

class SaveImageEvent extends ImageEvent {
  final String title;
  final Uint8List imageBytes;

  SaveImageEvent({required this.title, required this.imageBytes});

  @override
  List<Object> get props => [title, imageBytes];
}

class UpdateImageEvent extends ImageEvent {
  final int id;
  final String title;
  final Uint8List imageBytes;

  UpdateImageEvent(
      {required this.id, required this.title, required this.imageBytes});

  @override
  List<Object> get props => [id, title, imageBytes];
}
