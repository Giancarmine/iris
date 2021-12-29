import 'package:get/get.dart';
import 'package:iris/db/db_helper.dart';
import 'package:iris/models/notification.dart';

class NotificationController extends GetxController {
  @override
  void onReady() {
    getNotifications();
    super.onReady();
  }

  var notificationList = <Notification>[].obs;

  Future<int> addNotification({Notification? notification}) async {
    return await DBHelper.insertNotification(notification);
  }

  void getNotifications() async {
    List<Map<String, dynamic>> notifications =
        await DBHelper.queryNotifications();
    notificationList.assignAll(
        notifications.map((data) => Notification.fromJson(data)).toList());
  }

  void deleteNotification(Notification notification) async {
    await DBHelper.deleteNotification(notification);
    getNotifications();
  }
}
