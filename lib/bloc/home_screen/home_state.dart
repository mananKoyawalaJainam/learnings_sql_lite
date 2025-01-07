import 'package:sql_lite/models/picture.dart';

abstract class HomeState {}

class PictureLoading extends HomeState {}

class PictureLoaded extends HomeState {
  final List<Picture> pictures;

  PictureLoaded({required this.pictures});
}

class PictureLoadingError extends HomeState {
  final String message;

  PictureLoadingError({required this.message});
}

class PictureSaving extends HomeState {}

class PictureSaveError extends HomeState {
  final String message;

  PictureSaveError({required this.message});
}

class PictureDeleting extends HomeState {}

class PictureDeleteError extends HomeState {
  final String message;

  PictureDeleteError({required this.message});
}

class PictureUpdate extends HomeState {}

class PictureUpdateError extends HomeState {
  final String message;

  PictureUpdateError({required this.message});
}
