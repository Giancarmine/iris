import 'package:get/get.dart';
import 'package:iris/db/db_helper.dart';
import 'package:iris/models/task.dart';

class TaskController extends GetxController {
  @override
  void onReady() {
    super.onReady();
  }

  Future<int> addTask({Task? task}) async {
    return await DBHelper.insert(task);
  }
}
