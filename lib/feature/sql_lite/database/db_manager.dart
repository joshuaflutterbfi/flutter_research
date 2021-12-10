import 'dart:io';
import 'package:flutter_research/feature/sql_lite/model/data.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseManager {
  static final _dbName = "Database.db";
  // Use this class as a singleton
  DatabaseManager._privateConstructor();
  static final DatabaseManager instance = DatabaseManager._privateConstructor();
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    // Instantiate the database only when it's not been initialized yet.
    _database = await _initDatabase();
    return _database;
  }

  // Creates and opens the database.
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _dbName);
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  // Creates the database structure
  Future _onCreate(
    Database db,
    int version,
  ) async {
    await db.execute('''
          CREATE TABLE TVSeries (
            id INTEGER PRIMARY KEY,
            title TEXT NOT NULL,
            image BLOB,
            episodes INTEGER,
            description TEXT
          )
          ''');
  }

  Future<List<TVSeries>> fetchAllTvSeries() async {
    Database database = _database;
    List<Map<String, dynamic>> maps = await database.query('TVSeries');
    if (maps.isNotEmpty) {
      return maps.map((map) => TVSeries.fromDbMap(map)).toList();
    }
    return null;
  }

  Future<int> addTVSeries(TVSeries tvSeries) async {
    Database database = _database;
    return database.insert(
      'TVSeries',
      tvSeries.toDbMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
