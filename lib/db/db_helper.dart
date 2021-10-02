import 'package:iris/models/task.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Database? _db;
  static const int _version = 1;
  static const String _tasksTableName = "tasks";

  static Future<void> initDB() async {
    if (_db != null) {
      return;
    }
    try {
      String _path = await getDatabasesPath() + "iris.db";
      _db =
          await openDatabase(_path, version: _version, onCreate: (db, version) {
        print("creating a new db");
        return db.execute(
          "CREATE TABLE $_tasksTableName ("
          "id INTEGER PRIMARY KEY AUTOINCREMENT,"
          "title STRING, "
          "note TEXT, "
          "date STRING, "
          "startTime STRING, "
          "endTime STRING, "
          "remind INTEGER, "
          "repeat STRING, "
          "color INTEGER, "
          "isCompleted INTEGER)",
        );
      });
    } catch (e) {
      print(e);
    }
  }

  static Future<int> insert(Task? task) async {
    print("Insert function called");
    return await _db!.insert(_tasksTableName, task!.toJson());
  }

  static Future<int> delete(Task task) async =>
      await _db!.delete(_tasksTableName, where: 'id = ?', whereArgs: [task.id]);

  static Future<List<Map<String, dynamic>>> query() async {
    print("query function called");
    return _db!.query(_tasksTableName);
  }

  static Future<int> updateComplete(int id) async {
    print("update function called");
    return await _db!.rawUpdate('''
    UPDATE tasks   
    SET isCompleted = ?
    WHERE id = ?
    ''', [1, id]);
  }
}
