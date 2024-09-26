import 'package:get/get.dart' as getx;
import 'package:dio/dio.dart';
import 'package:idmall/config/config.dart' as config;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

final dio = Dio();
DateTime today = DateTime.now();
String formattedDate = DateFormat('yyyy-MM').format(today);

class FeedbackService extends getx.GetxService {
  //insert or save e-sign
  Future<dynamic> insertFeedback(String category, String feedback) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String token = prefs.getString('token') ?? "";
      final String taskid = prefs.getString("taskId") ?? "";

      print(category);
      print(feedback);
      print(taskid);

      var response = await dio.post(
        '${config.backendBaseUrl}/complaint/idmall-customer',
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token"
          },
        ),
        data: {
          "category": category,
          "message": feedback,
          "task_id": taskid,
        },
      );

      var result = response.data;
      return result;
    } catch (error) {
      print(error);
      throw Exception('Failed to save feedback data: $error');
    }
  }
}
