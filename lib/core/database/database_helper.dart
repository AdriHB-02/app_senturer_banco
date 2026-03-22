import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'migrations/v1_initial.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  static const int _currentVersion = 1;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'senturer_banco.db');

    return await openDatabase(
      path,
      version: _currentVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      onConfigure: _onConfigure,
    );
  }

  Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<void> _onCreate(Database db, int version) async {
    await MigrationV1Initial.execute(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {
      for (int v = oldVersion + 1; v <= newVersion; v++) {
        await _runMigration(db, v);
      }
    }
  }

  Future<void> _runMigration(Database db, int version) async {
    switch (version) {
      case 2:
        break;
    }
  }

  Future<int> insert(String table, Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert(table, data, conflictAlgorithm: ConflictAlgorithm.abort);
  }

  Future<List<Map<String, dynamic>>> queryAll(String table) async {
    final db = await database;
    return await db.query(table);
  }

  Future<Map<String, dynamic>?> queryById(String table, int id) async {
    final db = await database;
    final result = await db.query(table, where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty ? result.first : null;
  }

  Future<List<Map<String, dynamic>>> queryByField(
    String table,
    String field,
    dynamic value,
  ) async {
    final db = await database;
    return await db.query(table, where: '$field = ?', whereArgs: [value]);
  }

  Future<List<Map<String, dynamic>>> queryByFieldOrdered(
    String table,
    String field,
    dynamic value,
    String orderBy,
    int? limit,
  ) async {
    final db = await database;
    return await db.query(
      table,
      where: '$field = ?',
      whereArgs: [value],
      orderBy: orderBy,
      limit: limit,
    );
  }

  Future<int> update(
    String table,
    Map<String, dynamic> data,
    int id,
  ) async {
    final db = await database;
    return await db.update(table, data, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateByField(
    String table,
    Map<String, dynamic> data,
    String field,
    dynamic value,
  ) async {
    final db = await database;
    return await db.update(table, data, where: '$field = ?', whereArgs: [value]);
  }

  Future<int> delete(String table, int id) async {
    final db = await database;
    return await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }
}
