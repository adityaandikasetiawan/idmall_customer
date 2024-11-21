import 'package:get/get.dart' as getx;
import 'package:dio/dio.dart';
import 'package:idmall/config/config.dart' as config;
import 'package:idmall/models/customer_detail2.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

final dio = Dio();
DateTime today = DateTime.now();
String formattedDate = DateFormat('yyyy-MM').format(today);

class AccountService extends getx.GetxService {
  //search cid to get detail data
  Future<CustomerDetail2> searchCustomerId(String taskId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String token = prefs.getString('token')!;

      final response = await dio.get(
        "${config.backendBaseUrl}/customer/detail/$taskId",
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
            "Cache-Control": "no-cache"
          },
        ),
      );
      return CustomerDetail2.fromJson(response.data['data']);
    } catch (error) {
      throw Exception('Failed to fetch dashboard data: $error');
    }
  }

  //update account
  Future<dynamic> updateAccount(
    String taskId,
    String validationType,
    String validationData,
    String newData,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String token = prefs.getString('token')!;
      final String email = prefs.getString('email')!;

      if (newData == "") {
        newData = email;
      }

      final response = await dio.patch(
        "${config.backendBaseUrl}/update-account",
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
            "Cache-Control": "no-cache"
          },
        ),
        data: {
          "task_id": taskId,
          "validation_type": validationType,
          "data_to_validate": validationData,
          "updated_data": newData,
        },
      );
      return response.data;
    } catch (error) {
      throw Exception('Failed to fetch dashboard data: $error');
    }
  }

  //update email / phone number
  Future<dynamic> updateAccountData(
    String typeData,
    String data,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String token = prefs.getString('token') ?? "";
      final String taskId = prefs.getString('taskId') ?? "";

      final response = await dio.patch(
        "${config.backendBaseUrl}/account/connect",
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
            "Cache-Control": "no-cache"
          },
        ),
        data: {
          "task_id": taskId,
          "connect_by": typeData,
          "updated_data": data,
        },
      );
      return response.data;
    } catch (e) {
      throw Exception('Failed to fetch dashboard data: $e');
    }
  }

  //request otp
  Future<dynamic> requestOtp(
    String phoneNumber,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String token = prefs.getString('token') ?? "";

      String fixPhoneNumber = "62$phoneNumber";

      final response = await dio.post(
        "${config.backendBaseUrl}/otp/request",
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
            "Cache-Control": "no-cache"
          },
        ),
        data: {
          "target_phone_number": fixPhoneNumber,
        },
      );
      return response.data;
    } catch (e) {
      throw Exception('Failed to fetch dashboard data: $e');
    }
  }

  Future<dynamic> validationOtp(String phoneNumber, String otpNumber) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String token = prefs.getString('token') ?? "";

      String fixPhoneNumber = "62$phoneNumber";

      final response = await dio.post(
        "${config.backendBaseUrl}/otp/verify",
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
            "Cache-Control": "no-cache"
          },
        ),
        data: {
          "otp_number": otpNumber,
          "phone_number": fixPhoneNumber,
        },
      );
      return response.data;
    } catch (e) {
      throw Exception('Failed to verify otp number: $e');
    }
  }
}
