// ignore_for_file: camel_case_types

import 'package:get/get.dart';
import 'package:idmall/models/product_flyer.dart';
import 'package:idmall/service/product.dart';

class ProductController extends GetxController {
  final ProductService productService = Get.put(ProductService());

  //detail product
  Rx<ProductFlyer> detailProduct = ProductFlyer(
    id: 0,
    category: "",
    name: "",
    speed: 0,
    price: 0,
    code: "",
    path: "",
  ).obs;

  //loading parameter
  RxBool isLoading = false.obs;

  //function for fetch detail product
  Future<void> fetchDetailProduct(String id) async {
    try {
      isLoading(true);
      var result = await productService.getProductDetail(id);
      detailProduct.value = result;
    } catch (e) {
      Get.snackbar('Error', 'Failed to get detail product');
    } finally {
      isLoading(false);
    }
  }
}
