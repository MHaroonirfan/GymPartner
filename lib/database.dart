import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHandler {
  static Database? _database;

  static final DatabaseHandler instance = DatabaseHandler._init();

  DatabaseHandler._init();

  Future<Database> getDatabase() async {
    if (_database != null) {
      return _database!;
    } else {
      _database = await initDatabase();
      return _database!;
    }
  }

  Future<Database> initDatabase() async {
    String path = await getDatabasesPath();
    String dbPath = join(path, "gym_database.db");

    return await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
            "CREATE TABLE Days (day_id INTEGER PRIMARY KEY AUTOINCREMENT, day TEXT UNIQUE)");
        await db.execute(
            "CREATE TABLE Excercises (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, weight INTEGER, sets INTEGER, reps INTEGER,duration INTEGER, day_id INTEGER, FOREIGN KEY (day_id) REFERENCES Days(day_id) ON DELETE CASCADE)");

        await db.execute(
            "CREATE TABLE PrevDays (day_id INTEGER PRIMARY KEY AUTOINCREMENT, day TEXT, date TEXT)");
        await db.execute(
            "CREATE TABLE DoneExcercises (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, weight INTEGER, sets INTEGER, reps INTEGER,day_id INTEGER, FOREIGN KEY (day_id) REFERENCES PrevDays(day_id) ON DELETE CASCADE)");
      },
    );
  }

  Future insertInDB(String table, Map<String, dynamic> values) async {
    await _database!
        .insert(table, values, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Map<String, dynamic>?> getFromDB(
      String table, String whereKey, dynamic whereArg) async {
    List<Map<String, dynamic>> result = await _database!
        .query(table, where: "$whereKey = ?", whereArgs: [whereArg]);

    if (result.isNotEmpty) {
      return result.first;
    } else {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getExercisesFromDB(
      String table, String whereKey, dynamic whereArg) async {
    List<Map<String, dynamic>> result = await _database!
        .query(table, where: "$whereKey = ?", whereArgs: [whereArg]);

    return result;
  }

  Future deleteARow(String table, String whereKey, dynamic whereArg) async {
    await _database!
        .delete(table, where: "$whereKey = ?", whereArgs: [whereArg]);
  }
}
