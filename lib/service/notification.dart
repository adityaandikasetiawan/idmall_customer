import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:idmall/models/notification.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:idmall/config/config.dart' as config;

final dio = Dio();
DateTime today = DateTime.now();
String formattedDate = DateFormat('yyyy-MM').format(today);

class NotificationService extends GetxService {
  //get all notification by email dan taskid
  Future<List<NotificationResponse>> getAllNotification() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String token = prefs.getString('token') ?? "";
      final String taskid = prefs.getString('taskId') ?? "";

      final response = await dio.get(
        "${config.backendBaseUrl}/notification/get/all",
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
            "Cache-Control": "no-cache",
          },
        ),
        data: {
          "task_id": taskid,
        },
      );

      List<dynamic> data = response.data['data'];
      List<NotificationResponse> lists =
          data.map((json) => NotificationResponse.fromJson(json)).toList();
      return lists;
    } catch (e) {
      throw Exception('Failed to get notification list: $e');
    }
  }

  Future<bool> readNotification(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String token = prefs.getString('token') ?? "";

      final response = await dio.post(
        "${config.backendBaseUrl}/notification/read",
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
            "Cache-Control": "no-cache",
          },
        ),
        data: {
          "id": id,
        },
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception('Failed to read notification: $e');
    }
  }
}
