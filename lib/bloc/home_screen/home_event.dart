import 'package:equatable/equatable.dart';
import 'package:sql_lite/models/picture.dart';

abstract class HomeEvents extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadPictures extends HomeEvents {}

class SavePicture extends HomeEvents {
  final Picture picture;

  SavePicture({required this.picture});

  @override
  List<Object> get props => [picture];
}

class DeletePicture extends HomeEvents {
  final int id;

  DeletePicture({required this.id});

  @override
  List<Object> get props => [id];
}

class UpdatePicture extends HomeEvents {
  final Picture picture;

  UpdatePicture({required this.picture});

  @override
  List<Object> get props => [picture];
}
