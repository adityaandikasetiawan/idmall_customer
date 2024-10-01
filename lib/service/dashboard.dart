import 'package:get/get.dart' as getx;
import 'package:dio/dio.dart';
import 'package:idmall/config/config.dart' as config;
import 'package:idmall/models/dashboard.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

final dio = Dio();
DateTime today = DateTime.now();
String formattedDate = DateFormat('yyyy-MM').format(today);

class DashboardService extends getx.GetxService {
  //get all data for dashboard
  Future<DashboardModel> dashboardData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String token = prefs.getString('token') ?? "";

      final response = await dio.get(
        "${config.backendBaseUrl}/customer/dashboard",
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Cache-Control": "no-cache",
            "Authorization": "Bearer $token"
          },
        ),
      );

      return DashboardModel.fromJson(response.data['data']);
    } catch (error) {
      throw Exception('Failed to fetch dashboard data: $error');
    }
  }
}
