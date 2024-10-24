// ignore_for_file: non_constant_identifier_names, empty_catches

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:idmall/controller/payment.controller.dart';
import 'package:idmall/pages/invoice_testing.dart';
import 'package:idmall/pages/payment/payment_method.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:idmall/config/config.dart' as config;
import 'package:intl/intl.dart';

class PaymentMethodExisting extends StatefulWidget {
  final String taskid;
  final String billStatus;
  const PaymentMethodExisting({
    super.key,
    required this.taskid,
    required this.billStatus,
  });

  @override
  State<PaymentMethodExisting> createState() => _PaymentMethodExistingState();
}

class _PaymentMethodExistingState extends State<PaymentMethodExisting> {
  final PaymentController paymentController = Get.put(PaymentController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      paymentController.getPaymentDetailTransaction(widget.taskid);
      paymentController.getPaymentMethod();
    });
  }

  final oCcy = NumberFormat("#,##0", "en_US");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail Pembayaran',
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.white,
          ), //
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                Color(0xFFFFC107),
                Color(0xFFFFA000),
              ],
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Obx(
            () {
              if (paymentController.isLoading.value) {
                return Center(
                  child: SpinKitFadingCircle(
                    color: Colors.grey,
                    size: 50.0,
                  ),
                );
              } else {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          "Detail Paket",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: Container(
                            height: 2,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Kode Layanan:'),
                        Text(
                          paymentController.paymentDetail.value.services,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Nama Layanan:'),
                        Text(
                          paymentController.paymentDetail.value.subProduct,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                          maxLines: 2,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    Row(
                      children: [
                        const Text(
                          "Detail Tagihan",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: Container(
                            height: 2,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Tagihan:'),
                        Text(
                          oCcy
                              .format(paymentController
                                  .paymentDetail.value.monthlyPrice)
                              .replaceAll(",", "."),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Pajak(11%):'),
                        Text(
                          oCcy
                              .format(paymentController.paymentDetail.value.vat)
                              .replaceAll(",", "."),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Biaya Instalasi:'),
                        Text(
                          oCcy
                              .format(paymentController
                                  .paymentDetail.value.installation)
                              .replaceAll(",", "."),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          oCcy
                              .format(
                                  paymentController.paymentDetail.value.total)
                              .replaceAll(",", "."),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        const Text(
                          "Status Tagihan",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: Container(
                            height: 2,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Terbayar:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          oCcy
                              .format(
                                  paymentController.paymentDetail.value.arPaid)
                              .replaceAll(",", "."),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Sisa:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          oCcy
                              .format(paymentController
                                  .paymentDetail.value.arRemain)
                              .replaceAll(",", "."),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Status:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          widget.billStatus,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Divider(),
                    widget.billStatus != "Terbayar"
                        ? Center(
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  Get.to(
                                    () => PaymentMethodPage(
                                      taskid: widget.taskid,
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.amber,
                                ),
                                child: Text(
                                  "Pilih Metode Pembayaran",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : const SizedBox(
                            height: 0,
                          ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget buildPaymentMethodCard(
    String imagePath,
    String bankCode,
    String bankName,
    String typePayment,
    String total,
    context, {
    required double cardWidth,
    required double cardHeight,
    required double imageWidth,
    required double imageHeight,
  }) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () async {
          try {
            final prefs = await SharedPreferences.getInstance();
            final String token = prefs.getString('token') ?? "";
            final dio = Dio();
            final response3 = await dio.post(
              "${config.backendBaseUrl}/transaction/create",
              data: {
                "task_id": widget.taskid,
                "payment_method_code": bankCode,
                "payment_type": typePayment,
                "total_payment": total.replaceAll(",", ""),
                "status": "existing"
              },
              options: Options(
                headers: {
                  "Content-Type": "application/json",
                  "Authorization": "Bearer $token"
                },
              ),
            );
            String paymentCode = response3.data['data']['payment_code'];

            if (response3.statusCode == 200) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (builder) => InvoicePage(
                    taskid: widget.taskid,
                    bankName: bankName,
                    total: total,
                    typePayment: typePayment,
                    paymentCode: paymentCode,
                  ),
                ),
              );
            }
          } catch (e) {}
        },
        child: SizedBox(
          width: cardWidth,
          height: cardHeight,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Image.network(
                    imagePath,
                    width: imageWidth,
                    height: imageHeight,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(
                  width: 100,
                ),
                Expanded(
                  child: Text(
                    bankName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
