import 'package:get/get.dart';
import 'package:iris/db/db_helper.dart';
import 'package:iris/models/measurement.dart';

class MeasurementController extends GetxController {
  @override
  void onReady() {
    getMeasurements();
    super.onReady();
  }

  var measurementList = <Measurement>[].obs;

  Future<int> addMeasurement({Measurement? measurement}) async {
    return await DBHelper.insertMeasurement(measurement);
  }

  void getMeasurements() async {
    List<Map<String, dynamic>> measurements =
        await DBHelper.queryMeasurements();
    measurementList.assignAll(
        measurements.map((data) => Measurement.fromJson(data)).toList());
  }

  void deleteMeasurement(Measurement measurement) async {
    await DBHelper.deleteMeasurement(measurement);
    getMeasurements();
  }
}
