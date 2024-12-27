import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:taskmobile/models/TaskLogger.dart';
import 'package:taskmobile/models/tasks.dart';

// const String filaName = "tasks.db";

class AppDatabase {
  static final AppDatabase instance = AppDatabase._init();
  static Database? _database;

  AppDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('TasksM3.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final boolType = "BOOLEAN NOT NULL";
    final idType = "INTEGER PRIMARY KEY AUTOINCREMENT";
    final textTypeNullable = "TEXT";
    final textType = "TEXT NOT NULL";
    final intType = "INTEGER ";

    await db.execute('''
        CREATE TABLE $tableName (
          ${TaskFields.idField} $idType,
          ${TaskFields.titleField} $textType,
          ${TaskFields.descriptionField} $textTypeNullable,
          ${TaskFields.deadlineField} $textType,
          ${TaskFields.is_syncedField} $boolType
        )
      ''');

    await db.execute('''
        CREATE TABLE $tableName2 (
          ${TaskLoggerFields.idField} $idType,
          ${TaskLoggerFields.tidField} $intType,
          ${TaskLoggerFields.titleField} $textType,
          ${TaskLoggerFields.descriptionField} $textTypeNullable,
          ${TaskLoggerFields.deadlineField} $textType,
          ${TaskLoggerFields.last_updatedField} $textType,
          ${TaskLoggerFields.is_syncedField} $boolType,
          ${TaskLoggerFields.is_deletedField} $boolType,
          ${TaskLoggerFields.tuidField} $textTypeNullable
        )
      ''');
  }

  Future<Task> createTask(Task task) async {
    final db = await instance.database;
    final id = await db.insert(tableName, task.toJson());
    return task.copyWith(id: id);
  }

  Future<TaskLogger> createTaskLogger(TaskLogger task) async {
    final db = await instance.database;
    final id = await db.insert(tableName2, task.toJson());
    return task.copyWith(id: id);
  }

  Future<List<Task>> readAllTask() async {
    final db = await instance.database;
    final oderBy = '${TaskFields.deadlineField} DESC';
    final data = await db.query(tableName, orderBy: oderBy);
    return data.map((json) => Task.fromJson(json)).toList();
  }

  Future<List<TaskLogger>> readAllTaskLoggers() async {
    final db = await instance.database;
    final oderBy = '${TaskLoggerFields.deadlineField} DESC';
    final data = await db.query(tableName2, orderBy: oderBy);
    print(data.toString());
    return data.map((json) => TaskLogger.fromJson(json)).toList();
  }

//INSERTED FROM LOCAL AND NEVER SYNCED
  Future<List<TaskLogger>> readTaskLoggerUsecase1() async {
    final db = await instance.database;
    final sql = 'SELECT * FROM $tableName2 WHERE tuid IS NULL';
    final data = await db.rawQuery(sql);
    return data.map((json) => TaskLogger.fromJson(json)).toList();
  }

//SYNCED BY LATER MODIFIED
  Future<List<TaskLogger>> readTaskLoggerUsecase2() async {
    final db = await instance.database;
    final sql =
        'SELECT * FROM $tableName2 WHERE tuid IS NOT NULL AND ${TaskLoggerFields.is_syncedField} = 0 AND ${TaskLoggerFields.is_deletedField} = 0';
    final data = await db.rawQuery(sql);
    return data.map((json) => TaskLogger.fromJson(json)).toList();
  }

//SYNCED BY LATER DELETED
  Future<List<TaskLogger>> readTaskLoggerUsecase3() async {
    final db = await instance.database;
    final sql =
        'SELECT * FROM $tableName2 WHERE tuid IS NOT NULL AND is_deleted = 1';
    final data = await db.rawQuery(sql);
    return data.map((json) => TaskLogger.fromJson(json)).toList();
  }

  Future<List<TaskLogger>> readTaskLogger(int tid) async {
    final db = await instance.database;
    final sql = 'SELECT * FROM $tableName2 WHERE tid = $tid';
    final data = await db.rawQuery(sql);
    return data.map((json) => TaskLogger.fromJson(json)).toList();
  }

  Future<int> updateTask(Task task) async {
    final db = await instance.database;

    return await db.update(
      tableName,
      task.toJson(),
      where: '${TaskFields.idField} = ?',
      whereArgs: [task.id],
    );
  }

  Future<int> updateTaskLogger(TaskLogger task) async {
    final db = await instance.database;
    print('db');
    print(task.toString());
    return await db.update(
      tableName2,
      task.toJson(),
      where: '${TaskLoggerFields.tidField} = ?',
      whereArgs: [task.tid],
    );
  }

  Future<int> deleteTask(Task task) async {
    final db = await instance.database;

    return await db.delete(
      tableName,
      where: '${TaskFields.idField} = ?',
      whereArgs: [task.id],
    );
  }

  Future<int> deleteTaskLogger(TaskLogger task) async {
    final db = await instance.database;

    return await db.delete(
      tableName2,
      where: '${TaskLoggerFields.tidField} = ?',
      whereArgs: [task.tid],
    );
  }

  Future close() async {
    final db = await instance.database;
    return db.close();
  }
}
