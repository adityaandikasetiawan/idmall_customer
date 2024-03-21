import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:idmall/config/config.dart' as config;
import 'package:shared_preferences/shared_preferences.dart';

final dio = Dio();

Future getAllODPList() async {
  final prefs = await SharedPreferences.getInstance();
  final String token = prefs.getString('token') ?? "";

  final dio = Dio();
  final response = await dio.get(
    '${config.backendBaseUrl}/user/login',
    options: Options(headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    }),
  );
  return response;
}
