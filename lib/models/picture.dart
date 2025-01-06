import 'dart:typed_data';

class Picture {
  final int id;
  final String title;
  final Uint8List picture;

  Picture({required this.id, required this.title, required this.picture});

  factory Picture.fromJson(Map<String, dynamic> json) {
    return Picture(
        id: json["id"],
        title: json["title"],
        picture: json["picture"] as Uint8List);
  }

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "picture": picture,
      };

  Picture copy({int? id, String? title, Uint8List? picture}) => Picture(
      id: id ?? this.id,
      title: title ?? this.title,
      picture: picture ?? this.picture);
}

class PictureFields {
  static const String tableName = 'pictures';
  static const String id = 'id';
  static const String title = 'title';
  static const String picture = 'picture';
  static const String idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
  static const String titleType = 'TEXT NOT NULL';
  static const String pictureType = 'BLOB';
}
