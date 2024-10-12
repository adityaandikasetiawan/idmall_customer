import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:idmall/controller/product.controller.dart';
import 'package:idmall/pages/google_maps.dart';
import 'package:idmall/pages/signup.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class DetailPage extends StatefulWidget {
  final String ids;
  final int isGuest;

  const DetailPage({
    super.key,
    required this.ids,
    required this.isGuest,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final ProductController productController = Get.put(ProductController());

  final oCcy = NumberFormat("#,##0", "en_US");

  @override
  void initState() {
    super.initState();
    productController.fetchDetailProduct(widget.ids);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail'),
      ),
      body: Obx(
        () {
          if (productController.isLoading.value) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 400.0,
                      color: Colors.grey[300],
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      productController.detailProduct.value.path,
                      width: double.infinity,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        productController.detailProduct.value.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Rp. ${oCcy.format(productController.detailProduct.value.price).replaceAll(",", ".")}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shadowColor: Colors.orange,
                              backgroundColor: Colors.white,
                              side: const BorderSide(color: Colors.orange),
                            ),
                            onPressed: () {
                              if (widget.isGuest == 0) {
                                Get.to(
                                  () => MapSample(
                                    productCode: productController
                                        .detailProduct.value.code,
                                    productName: productController
                                        .detailProduct.value.name,
                                  ),
                                );
                              } else {
                                Get.to(
                                  () => SignUp(),
                                );
                              }
                            },
                            child: widget.isGuest == 0
                                ? const Text('Beli Sekarang!')
                                : const Text('Sign In'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
