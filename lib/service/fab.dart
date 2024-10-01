import 'dart:io';

import 'package:get/get.dart' as getx;
import 'package:dio/dio.dart';
import 'package:idmall/config/config.dart' as config;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

final dio = Dio();
DateTime today = DateTime.now();
String formattedDate = DateFormat('yyyy-MM').format(today);

class FabService extends getx.GetxService {
  //insert or save e-sign
  Future<dynamic> insertEsign(
      String taskId, String base64, String typeFile) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String token = prefs.getString('token') ?? "";

      FormData formData = FormData.fromMap({
        'signature': base64,
        'type': typeFile,
      });

      var response = await dio.post(
        '${config.backendBaseUrlProd}/subscription/signature/upload/$taskId',
        options: Options(
          headers: {
            "Content-Type": "multipart/form-data",
            "Authorization": "Bearer $token"
          },
        ),
        data: formData,
      );

      var result = response.data;
      return result;
    } catch (error) {
      throw Exception('Failed to fetch follow up comitment data: $error');
    }
  }

  //insert or upload ktp image
  Future<dynamic> insertNewIdcard(
    String taskId,
    File ktpImageFile,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String token = prefs.getString('token') ?? "";

      FormData formData2 = FormData.fromMap({
        'ktp': await MultipartFile.fromFile(ktpImageFile.path,
            filename: ktpImageFile.path.split('/').last),
        'task_id': '16063944',
      });

      var response = await dio.post(
        '${config.backendBaseUrlProd}/subscription/retail/fkb/user',
        options: Options(
          headers: {
            "Content-Type": "multipart/form-data",
            "Authorization": "Bearer $token"
          },
        ),
        data: formData2,
      );

      var result = response.data;
      return result;
    } catch (error) {
      throw Exception('Failed to fetch follow up comitment data: $error');
    }
  }

  Future<dynamic> submitFab(
    String taskId,
    String status,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String token = prefs.getString('token') ?? "";

      var response = await dio.post(
        '${config.backendBaseUrlProd}/submit-fab/16063944',
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token"
          },
        ),
        data: {
          "status_to": status,
        },
      );

      var result = response.data;
      return result;
    } catch (error) {
      throw Exception('Failed to fetch follow up comitment data: $error');
    }
  }
}
