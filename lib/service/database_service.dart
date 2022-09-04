import 'package:restaurant_app/models/restaurant_model.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  DatabaseService._instance();

  static final DatabaseService db = DatabaseService._instance();

  static Database? _database;

  factory DatabaseService() => db;

  ///CHECK DATABASE
  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await initializeDB();
    return _database;
  }

  initializeDB() async {
    var path = await getDatabasesPath();
    var db = await openDatabase(
      '$path/bookmark.db',
      version: 1,
      onCreate: (db, version) async {
        db.execute('''CREATE TABLE favorites(
            id TEXT PRIMARY KEY, 
            name TEXT, 
            city TEXT, 
            pictureId TEXT, 
            rating REAL)''');
      },
    );
    return db;
  }

  addFavorites(Restaurant restaurant) async {
    final db = await database;
    db!.insert(
      'favorites',
      restaurant.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Restaurant>> getFavorites() async {
    final db = await database;
    var res = await db!.query('favorites');

    if (res.isEmpty) {
      return [];
    } else {
      var resultMap =
          res.map((restaurant) => Restaurant.fromJson(restaurant)).toList();
      return resultMap.isNotEmpty ? resultMap : [];
    }
  }

  Future<Map<String, dynamic>> getFavoritesById(String id) async {
    final db = await database;
    List<Map<String, dynamic>> result = await db!.query(
      'favorites',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      return result.first;
    } else {
      return {};
    }
  }

  Future deleteFavorites(String id) async {
    final db = await database;
    await db!.delete(
      'favorites',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
