import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sql_lite/models/picture.dart';

class DBHelper {
  static final DBHelper instance = DBHelper._internal();

  static Database? _database;

  DBHelper._internal();

  // * get database instance
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  // * initialize the database
  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'pictures.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  // * create database
  Future<void> _createDatabase(Database db, _) async {
    await db.execute('''
    CREATE TABLE pictures (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL,
      picture BLOB NOT NULL
    )
''');
  }

  // * add image
  Future<Picture> addImage(Picture picture) async {
    final db = await instance.database;
    final id = await db.insert('pictures', {
      "title": picture.title,
      "picture": picture.picture,
    });
    return picture.copy(id: id);
  }

  // * get all images
  Future<List<Picture>> getAllPictures() async {
    final db = await instance.database;
    final result = await db.query('pictures');
    return result.map((json) => Picture.fromJson(json)).toList();
  }

  // * delete image
  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete(
      PictureFields.tableName,
      where: '${PictureFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future<int> update(int id, Picture picture) async {
    final db = await instance.database;
    return await db.update(
      PictureFields.tableName,
      {
        "picture": picture.picture,
      },
      where: '${PictureFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
