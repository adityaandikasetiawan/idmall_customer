import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:idmall/models/payment_history_detail.dart';
import 'package:idmall/models/payment_method.dart';
import 'package:idmall/models/payment_transaction.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:idmall/config/config.dart' as config;

final dio = Dio();
DateTime today = DateTime.now();
String formattedDate = DateFormat('yyyy-MM').format(today);

class PaymentService extends GetxService {
  //get detail transaction for payment
  Future<PaymentTransaction> getCart(String taskid) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String token = prefs.getString('token') ?? "";

      final response = await dio.get(
        "${config.backendBaseUrl}/transaction/ca/$taskid",
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
            "Cache-Control": "no-cache",
          },
        ),
      );

      return PaymentTransaction.fromJson(response.data['data'][0]);
    } catch (error) {
      throw Exception('Failed to get detail payment: $error');
    }
  }

  //get bank payment method by xendit
  Future<List<PaymentMethodModel>> getPaymentMethod() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String token = prefs.getString('token') ?? "";

      final response = await dio.get(
        "${config.backendBaseUrl}/payment-method",
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
            "Cache-Control": "no-cache",
          },
        ),
      );

      List<dynamic> data = response.data['data']['bank'];
      List<PaymentMethodModel> lists =
          data.map((json) => PaymentMethodModel.fromJson(json)).toList();
      return lists;
    } catch (e) {
      throw Exception('Failed to get payment method bank: $e');
    }
  }

  //create transaction to get VA number
  Future<Map<String, dynamic>> createTransaction(
    String taskid,
    String bankCode,
    String paymentType,
    int total,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token') ?? "";

    try {
      final response = await dio.post(
        "${config.backendBaseUrl}/transaction/create",
        data: {
          "task_id": taskid,
          "payment_method_code": bankCode,
          "payment_type": paymentType,
          "total_payment": total
        },
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token"
          },
        ),
      );

      if (response.statusCode == 200) {
        return {
          'status': response.data['status'],
          'message': response.data['message'],
          'payment_code': response.data['data']['payment_code'],
        };
      } else {
        return {
          'status': "error",
          'message': response.data['errors']['message'] ?? "Terjadi kesalahan",
        };
      }
    } catch (e) {
      throw Exception('Failed to create transaction: $e');
    }
  }

  //get history detail payment
  Future<PaymentHistoryDetail> getPaymentHistoryDetail(
    String taskid,
    String periode,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String token = prefs.getString('token') ?? "";

      final response = await dio.get(
        "${config.backendBaseUrl}/transaction/history/detail",
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
            "Cache-Control": "no-cache",
          },
        ),
        data: {
          "task_id": taskid,
          "period": periode,
        },
      );

      return PaymentHistoryDetail.fromJson(response.data['data'][0]);
    } catch (error) {
      throw Exception('Failed to get detail payment: $error');
    }
  }
}
