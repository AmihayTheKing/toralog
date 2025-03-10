import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:zman_limud_demo/models/learn_time.dart';

class LearnTimeDatabase {
  static final LearnTimeDatabase instance = LearnTimeDatabase._init();
  static Database? _database;
  final String tableName = 'learn_times';

  factory LearnTimeDatabase() {
    return instance;
  }

  LearnTimeDatabase._init();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDB('$tableName.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableName (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        start_time TEXT NOT NULL,
        end_time TEXT NOT NULL,
        date TEXT NOT NULL,
        category TEXT NOT NULL
      )
    ''');
  }

  Future<LearnTime> create(LearnTime learnTime) async {
    final db = await instance.database;
    await db.insert(tableName, learnTime.map);
    return learnTime;
  }

  Future<LearnTime?> readLearnTime(String id) async {
    final db = await instance.database;
    final maps = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return LearnTime.fromMap(maps.first);
    }
    return null;
  }

  Future<List<LearnTime>> readAllLearnTimes() async {
    final db = await instance.database;
    final orderBy = 'date DESC';
    final result = await db.query(tableName, orderBy: orderBy);
    return result.map((json) => LearnTime.fromMap(json)).toList();
  }

  // Update a learn time
  Future<int> update(LearnTime learnTime) async {
    final db = await instance.database;
    return db.update(
      tableName,
      learnTime.map,
      where: 'id = ?',
      whereArgs: [learnTime.id],
    );
  }

  Future<void> resetDatabase() async {
    try {
      final db = await database;

      // Delete all rows from learn_times table
      await db.delete(tableName);

      if (kDebugMode) {
        print('Database reset successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error resetting database: $e');
      }
      rethrow;
    }
  }

  Future<void> delete(LearnTime learnTime) async {
    try {
      final db = await database;
      int deletedCount = await db
          .delete(tableName, where: 'id = ?', whereArgs: [learnTime.id]);

      if (kDebugMode) {
        print('Delete operation result: $deletedCount rows deleted');
      }

      if (deletedCount == 0) {
        if (kDebugMode) {
          print('No rows deleted. Debugging info:');
        }
        if (kDebugMode) {
          print('Attempted to delete ID: ${learnTime.id}');
        }

        // Optionally, list all existing IDs to help diagnose
        final allTimes = await readAllLearnTimes();
        if (kDebugMode) {
          print('Current learn times IDs:');
        }
        for (var time in allTimes) {
          if (kDebugMode) {
            print(time.id);
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error in delete method: $e');
      }
      rethrow;
    }
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
