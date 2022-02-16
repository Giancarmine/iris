import 'package:get/get.dart';
import 'package:iris/db/db_helper.dart';
import 'package:iris/models/alarm.dart';

class AlarmController extends GetxController {
  @override
  void onReady() {
    getAlarms();
    super.onReady();
  }

  var alarmList = <Alarm>[].obs;

  Future<int> addAlarm({Alarm? alarm}) async {
    return await DBHelper.insertAlarm(alarm);
  }

  void getAlarms() async {
    List<Map<String, dynamic>> alarms = await DBHelper.queryAlarms();
    alarmList.assignAll(alarms.map((data) => Alarm.fromJson(data)).toList());
  }

  void deleteAlarm(Alarm alarm) async {
    await DBHelper.deleteAlarm(alarm);
    getAlarms();
  }
}
