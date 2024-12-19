import 'package:path/path.dart';
import 'package:singerapp/features/domain/models/schedule.dart';
import 'package:sqflite/sqflite.dart';

class ScheduleDatabase {
  static final ScheduleDatabase instance = ScheduleDatabase._init();
  static Database? _database;

  ScheduleDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('schedules.db');
    return _database!;
  }

  Future<int> update(Schedule schedule) async {
    final db = await database;

    return await db.update(
      'schedules',
      schedule.toJson(),
      where: 'id = ?',
      whereArgs: [schedule.id],
    );
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE schedules (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        location TEXT NOT NULL,
        amount REAL NOT NULL,
        isPaid INTEGER NOT NULL,
        showTime TEXT NOT NULL,
        hasAdditionalMusicians INTEGER NOT NULL,
        additionalMusicianFee REAL NOT NULL,
        isSynced INTEGER NOT NULL,
        isDownloaded INTEGER NOT NULL

      )
    ''');
  }

  Future<int> create(Schedule schedule) async {
    final db = await instance.database;
    return await db.insert('schedules', schedule.toMap());
  }

  Future<List<Schedule>> readAll() async {
    final db = await instance.database;
    final result = await db.query('schedules');
    return result.map((map) => Schedule.fromMap(map)).toList();
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete('schedules', where: 'id = ?', whereArgs: [id]);
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }

  Future<List<Schedule>> getUnsyncedSchedules() async {
    final db = await database;
    final result = await db.query(
      'schedules',
      where: 'isSynced = ?',
      whereArgs: [0],
    );
    return result.map((json) => Schedule.fromJson(json)).toList();
  }

  Future<bool> exists(int id) async {
    final db = await database;
    final result = await db.query(
      'schedules',
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty;
  }

  Future<Schedule> getById(int id) async {
    final db = await database;
    final result = await db.query(
      'schedules',
      where: 'id = ?',
      whereArgs: [id],
    );
    return Schedule.fromJson(result.first);
  }
}
