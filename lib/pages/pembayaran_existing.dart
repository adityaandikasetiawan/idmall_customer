// ignore_for_file: non_constant_identifier_names, empty_catches

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:idmall/controller/payment.controller.dart';
import 'package:idmall/models/payment_method.dart';
import 'package:idmall/pages/invoice_testing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:idmall/config/config.dart' as config;
import 'package:intl/intl.dart';

final PaymentController paymentController = Get.put(PaymentController());

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
  @override
  void initState() {
    super.initState();
    paymentController.getPaymentDetailTransaction(widget.taskid);
    paymentController.getPaymentMethod();
  }

  final oCcy = NumberFormat("#,##0", "en_US");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pembayaran',
          style: TextStyle(fontSize: 16.0), // Ubah ukuran font menjadi 16px
        ),
        centerTitle: true, // Posisikan judul ke tengah
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
                    const SizedBox(height: 8.0),
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
                    // const SizedBox(height: 8.0),
                    Divider(
                      height: 8,
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
                        ? Column(
                            children: [
                              const SizedBox(height: 8.0),
                              const Text(
                                'Metode Pembayaran:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 20.0),
                              ListView.builder(
                                shrinkWrap: true,
                                itemCount:
                                    paymentController.paymentMethodBank.length,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  PaymentMethodModel paymentMethodBank =
                                      paymentController
                                          .paymentMethodBank[index];
                                  return buildPaymentMethodCard(
                                    paymentMethodBank.iconURL,
                                    paymentMethodBank.code,
                                    paymentMethodBank.name,
                                    "BANK",
                                    paymentController.paymentDetail.value.total
                                        .toString(),
                                    context,
                                    cardWidth:
                                        MediaQuery.of(context).size.width,
                                    cardHeight: 120,
                                    imageWidth: 80,
                                    imageHeight: 80,
                                  );
                                },
                              ),
                              // ListView.builder(
                              //   shrinkWrap: true,
                              //   itemCount: paymentMethodListOutlet.length,
                              //   itemBuilder: (context, index) {
                              //     return buildPaymentMethodCard(
                              //       paymentMethodListOutlet[index].iconURL,
                              //       paymentMethodListOutlet[index].code,
                              //       paymentMethodListOutlet[index].name,
                              //       "OUTLET",
                              //       context,
                              //       cardWidth: MediaQuery.of(context).size.width,
                              //       cardHeight: 120,
                              //       imageWidth: 80,
                              //       imageHeight: 80,
                              //     );
                              //   },
                              // ),
                            ],
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
