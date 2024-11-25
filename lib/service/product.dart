import 'package:get/get.dart' as getx;
import 'package:dio/dio.dart';
import 'package:idmall/config/config.dart' as config;
import 'package:idmall/models/product_flyer.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

final dio = Dio();
DateTime today = DateTime.now();
String formattedDate = DateFormat('yyyy-MM').format(today);

class ProductService extends getx.GetxService {
  //get detail product
  Future<ProductFlyer> getProductDetail(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String token = prefs.getString('token') ?? "";

      final response = await dio.get(
        "${config.backendBaseUrlProd}/product/banner/$id",
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
            "Cache-Control": "no-cache"
          },
        ),
      );

      return ProductFlyer.fromJson(response.data['data'][0]);
    } catch (error) {
      throw Exception('Failed to detail product: $error');
    }
  }
}
