import 'package:sqflite/sqflite.dart';

import '../../src/restaurant/model/restaurant_model.dart';

class DatabaseHelper {
  static DatabaseHelper? _instance;
  static Database? _database;

  DatabaseHelper._internal() {
    _instance = this;
  }

  factory DatabaseHelper() => _instance ?? DatabaseHelper._internal();

  static const String _tblFavourite = 'favourite';

  Future<Database> _initializeDb() async {
    var path = await getDatabasesPath();
    var db = openDatabase(
      '$path/restaurantapp.db',
      onCreate: (db, version) async {
        await db.execute('''CREATE TABLE $_tblFavourite (
             id TEXT PRIMARY KEY,
             pictureId TEXT,
             name TEXT,
             description TEXT,
             city TEXT,
             rating REAL
           )     
        ''');
      },
      version: 1,
    );

    return db;
  }

  Future<Database?> get database async {
    _database ??= await _initializeDb();

    return _database;
  }

  Future<void> insertFavourite(Restaurant restaurant) async {
    final db = await database;
    await db!.insert(_tblFavourite, restaurant.toJson());
  }

  Future<List<Restaurant>> getFavourites() async {
    final db = await database;
    List<Map<String, dynamic>> results = await db!.query(_tblFavourite);

    return results.map((res) => Restaurant.fromJson(res)).toList();
  }

  Future<Map> getFavouriteByUrl(String id) async {
    final db = await database;

    List<Map<String, dynamic>> results = await db!.query(
      _tblFavourite,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isNotEmpty) {
      return results.first;
    } else {
      return {};
    }
  }

  Future<void> removeFavourite(String id) async {
    final db = await database;

    await db!.delete(
      _tblFavourite,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
