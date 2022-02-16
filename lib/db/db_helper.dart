import 'package:iris/models/alarm.dart';
import 'package:iris/models/measurement.dart';
import 'package:logger/logger.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static var logger = Logger();
  static Database? _db;
  static const int _version = 1;
  static const String _measurementsTableName = "measurements";
  static const String _alarmsTableName = "alarm";

  static Future<void> initDB() async {
    if (_db != null) {
      return;
    }
    try {
      String _path = await getDatabasesPath() + "iris.db";
      _db =
          await openDatabase(_path, version: _version, onCreate: (db, version) {
        logger.d("creating a new db");
        db.execute(
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
        db.execute(
          "CREATE TABLE $_alarmsTableName ("
          "id INTEGER PRIMARY KEY AUTOINCREMENT,"
          "date STRING, "
          "time STRING, "
          "remind INTEGER, "
          "color INTEGER, "
          "type INTEGER,"
          "repeat STRING)",
        );
      });
    } catch (e) {
      logger.d(e);
    }
  }

  static Future<int> insertMeasurement(Measurement? measurement) async {
    logger.d("Insert function called");
    return await _db!.insert(_measurementsTableName, measurement!.toJson());
  }

  static Future<int> insertAlarm(Alarm? alarm) async {
    print("InsertAlarm function called");
    return await _db!.insert(_alarmsTableName, alarm!.toJson());
  }

  static Future<int> deleteMeasurement(Measurement measurement) async =>
      await _db!.delete(_measurementsTableName,
          where: 'id = ?', whereArgs: [measurement.id]);

  static Future<int> deleteAlarm(Alarm alarm) async => await _db!
      .delete(_alarmsTableName, where: 'id = ?', whereArgs: [alarm.id]);

  static Future<List<Map<String, dynamic>>> queryMeasurements() async {
    logger.d("query function called");
    return _db!.query(_measurementsTableName);
  }

  static Future<List<Map<String, dynamic>>> queryAlarms() async {
    print("queryAlarms function called");
    return _db!.query(_alarmsTableName);
  }
}
