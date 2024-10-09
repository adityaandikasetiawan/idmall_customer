import 'package:get/get.dart';
import 'package:idmall/models/notification.dart';
import 'package:idmall/service/notification.dart';

class NotificationController extends GetxController {
  final NotificationService notificationService =
      Get.put(NotificationService());

  //notification list
  RxList<NotificationResponse> notificationList = <NotificationResponse>[].obs;

  //loading indicator
  RxBool isLoading = false.obs;

  //get all notification by taskid and email
  Future<void> fetchNotification() async {
    try {
      isLoading(true);
      var result = await notificationService.getAllNotification();
      notificationList.value = result;
    } catch (e) {
      Get.snackbar("Error", "Failed to get notification list");
    } finally {
      isLoading(false);
    }
  }

  //read all notification
  Future<void> readNotification(String id) async {
    try {
      isLoading(true);
      await notificationService.readNotification(id);
    } catch (e) {
      Get.snackbar("Error", "Faild to read notification");
    } finally {
      isLoading(false);
    }
  }
}
