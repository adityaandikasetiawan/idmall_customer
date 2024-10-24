import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:idmall/controller/payment.controller.dart';
import 'package:idmall/models/payment_method.dart';

class PaymentMethodPage extends StatefulWidget {
  final String taskid;
  const PaymentMethodPage({
    super.key,
    required this.taskid,
  });

  @override
  State<PaymentMethodPage> createState() => _PaymentMethodPageState();
}

class _PaymentMethodPageState extends State<PaymentMethodPage> {
  final PaymentController paymentController = Get.put(PaymentController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Metode Pembayaran",
          style: TextStyle(
            color: Colors.white,
            fontFamily: "Inter",
          ),
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
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: EdgeInsets.all(16.0),
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
                  children: [
                    Row(
                      children: [
                        const Text("Bank"),
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
                    const SizedBox(height: 20.0),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: paymentController.paymentMethodBank.length,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        PaymentMethodModel paymentMethodBank =
                            paymentController.paymentMethodBank[index];
                        return buildPaymentMethodCard(
                          paymentMethodBank.iconURL,
                          paymentMethodBank.code,
                          paymentMethodBank.name,
                          "BANK",
                          paymentController.paymentDetail.value.total
                              .toString(),
                          context,
                          cardWidth: MediaQuery.of(context).size.width,
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
          paymentController.createNewTransaction(
            widget.taskid,
            bankCode,
            typePayment,
            int.parse(total),
          );
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
