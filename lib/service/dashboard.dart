import 'package:get/get.dart' as getx;
import 'package:dio/dio.dart';
import 'package:idmall/config/config.dart' as config;
import 'package:idmall/models/customer_by_email.dart';
import 'package:idmall/models/dashboard.dart';
import 'package:idmall/models/product_flyer.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

final dio = Dio();
DateTime today = DateTime.now();
String formattedDate = DateFormat('yyyy-MM').format(today);

class DashboardService extends getx.GetxService {
  //get all data for dashboard
  Future<DashboardModel?> getDashboardData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String token = prefs.getString('token') ?? "";

      final response = await dio.get(
        "${config.backendBaseUrlProd}/customer/dashboard/detail-customer",
        options: Options(headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
          "Cache-Control": "no-cache"
        }),
      );

      if (response.data['data'].length > 0) {
        final response2 = await dio.get(
          "${config.backendBaseUrlProd}/customer/dashboard",
          options: Options(
            headers: {
              "Content-Type": "application/json",
              "Cache-Control": "no-cache",
              "Authorization": "Bearer $token"
            },
          ),
          data: {
            "task_id": response.data['data']['Task_ID'],
          },
        );
        return DashboardModel.fromJson(response2.data['data']);
      }
      return null;
    } catch (error) {
      throw Exception('Failed to fetch dashboard data: $error');
    }
  }

  //get all task id by email
  Future<List<CustomerListByEmail>> getTaskIdByEmail() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String token = prefs.getString('token') ?? "";

      final response = await dio.get(
        "${config.backendBaseUrl}/customer/billing/list",
        options: Options(headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
          "Cache-Control": "no-cache"
        }),
      );
      List<dynamic> data = response.data['data'];
      List<CustomerListByEmail> lists =
          data.map((json) => CustomerListByEmail.fromJson(json)).toList();
      return lists;
    } catch (e) {
      throw Exception('Failed to get all task id by email: $e');
    }
  }

  //get updated token
  Future<DashboardModel> getUpdatedToken(String taskid) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String token = prefs.getString('token') ?? "";

      final response = await dio.get(
        "${config.backendBaseUrlProd}/billing/get",
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
            "Cache-Control": "no-cache"
          },
        ),
        data: {
          "task_id": taskid,
        },
      );
      //change token and customer name
      await prefs.setString(
        "token",
        response.data['data'][0]['Updated_Auth_Token'],
      );
      await prefs.setString(
        "fullName",
        response.data['data'][0]['Customer_Sub_Name'],
      );

      //update detail
      final response2 = await dio.get(
        "${config.backendBaseUrl}/customer/dashboard",
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Cache-Control": "no-cache",
            "Authorization": "Bearer $token"
          },
        ),
        data: {
          "task_id": response.data['data'][0]['Task_ID'].toString(),
        },
      );
      return DashboardModel.fromJson(response2.data['data']);
    } catch (e) {
      // print(e);
      throw Exception('Failed to update token and detail: $e');
    }
  }

  //get product by category
  Future<List<ProductFlyer>> getProductHome(String category) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String token = prefs.getString('token') ?? "";

      final response = await dio.get(
        "${config.backendBaseUrlProd}/product/banner",
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
            "Cache-Control": "no-cache"
          },
        ),
        queryParameters: {
          "category": category,
        },
      );

      List<dynamic> data = response.data['data'];
      List<ProductFlyer> lists =
          data.map((json) => ProductFlyer.fromJson(json)).toList();
      return lists;
    } catch (e) {
      throw Exception('Failed to get product list: $e');
    }
  }

  Future<List<ProductFlyer>> getProductBisnis(String category) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String token = prefs.getString('token') ?? "";

      final response = await dio.get(
        "${config.backendBaseUrlProd}/product/banner",
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
            "Cache-Control": "no-cache"
          },
        ),
        queryParameters: {
          "category": category,
        },
      );

      List<dynamic> data = response.data['data'];
      List<ProductFlyer> lists =
          data.map((json) => ProductFlyer.fromJson(json)).toList();
      return lists;
    } catch (e) {
      throw Exception('Failed to get product list: $e');
    }
  }
}
