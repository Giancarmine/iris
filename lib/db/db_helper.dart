import 'package:iris/models/measurement.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Database? _db;
  static const int _version = 1;
  static const String _measurementsTableName = "measurements";

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
          "CREATE TABLE $_measurementsTableName ("
          "id INTEGER PRIMARY KEY AUTOINCREMENT,"
          "value INTEGER, "
          "note TEXT, "
          "date STRING, "
          "time STRING, "
          "remind INTEGER, "
          "color INTEGER, "
          "type INTEGER)",
        );
      });
    } catch (e) {
      print(e);
    }
  }

  static Future<int> insertMeasurement(Measurement? measurement) async {
    print("Insert function called");
    return await _db!.insert(_measurementsTableName, measurement!.toJson());
  }

  static Future<int> deleteMeasurement(Measurement measurement) async =>
      await _db!.delete(_measurementsTableName, where: 'id = ?', whereArgs: [measurement.id]);

  static Future<List<Map<String, dynamic>>> queryMeasurement() async {
    print("query function called");
    return _db!.query(_measurementsTableName);
  }
}
