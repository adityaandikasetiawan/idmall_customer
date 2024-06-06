// ignore_for_file: non_constant_identifier_names, empty_catches

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:idmall/models/payment_method.dart';
import 'package:idmall/models/payment_method_model.dart';
import 'package:idmall/pages/invoice_testing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:idmall/config/config.dart' as config;
import 'package:intl/intl.dart';

class PaymentMethod extends StatefulWidget {
  final String taskid;
  const PaymentMethod({
    super.key,
    required this.taskid,
  });

  @override
  State<PaymentMethod> createState() => _PaymentMethodState();
}

class _PaymentMethodState extends State<PaymentMethod> {
  @override
  void initState() {
    super.initState();
    getPaymentMethod();
    getCart();
  }

  List<PaymentMethodModel> paymentMethodListBank = [];
  List<PaymentMethodModelOutlet> paymentMethodListOutlet = [];
  final oCcy = NumberFormat("#,##0", "en_US");
  String? vat;
  String? monthly_price;
  String? total;
  String? installation_fee;

  Future<void> getPaymentMethod() async {
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token') ?? "";
    final dio = Dio();
    final response = await dio.get(
      "${config.backendBaseUrl}/payment-method",
      options: Options(headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      }),
    );
    for (var ele in response.data['data']['bank']) {
      paymentMethodListBank.add(PaymentMethodModel.fromJson(ele));
    }
    for (var ele2 in response.data['data']['outlet']) {
      paymentMethodListOutlet.add(PaymentMethodModelOutlet.fromJson(ele2));
    }

    setState(() {});
  }

  Future<void> getCart() async {
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token') ?? "";
    final dio = Dio();
    final response2 = await dio.get(
      "${config.backendBaseUrl}/transaction/ca/${widget.taskid}",
      options: Options(headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      }),
    );
    var result2 = response2.data['data'][0];
    setState(() {
      vat = oCcy.format(result2['vat']).replaceAll(",", ".");
      monthly_price = oCcy.format(result2['Monthly_Price']);
      total = oCcy.format(result2['total']);
      installation_fee = result2['Installation'] != null
          ? oCcy.format(result2['Installation']).replaceAll(",", ".")
          : '0';
    });
  }

  Future<bool> createTransaction(bankCode, paymentType) async {
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token') ?? "";
    final dio = Dio();
    final response3 = await dio.post(
      "${config.backendBaseUrl}/transaction/ca/${widget.taskid}",
      data: {
        "task_id": widget.taskid,
        "payment_method_code": bankCode,
        "payment_type": paymentType,
        "total_payment": total
      },
      options: Options(headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      }),
    );

    if (response3.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Pesanan:'),
                  Text(
                    '$monthly_price',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Pajak(11%):'),
                  Text(
                    '$vat',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Biaya Instalasi:'),
                  Text(
                    '$installation_fee',
                    style: const TextStyle(fontWeight: FontWeight.bold),
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
                    '$total',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              const Divider(),
              const SizedBox(height: 8.0),
              const Text(
                'Metode Pembayaran:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20.0),
              ListView.builder(
                shrinkWrap: true,
                itemCount: paymentMethodListBank.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return buildPaymentMethodCard(
                    paymentMethodListBank[index].iconURL,
                    paymentMethodListBank[index].code,
                    paymentMethodListBank[index].name,
                    "BANK",
                    context,
                    cardWidth: MediaQuery.of(context).size.width,
                    cardHeight: 120,
                    imageWidth: 80,
                    imageHeight: 80,
                  );
                },
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: paymentMethodListOutlet.length,
                itemBuilder: (context, index) {
                  return buildPaymentMethodCard(
                    paymentMethodListOutlet[index].iconURL,
                    paymentMethodListOutlet[index].code,
                    paymentMethodListOutlet[index].name,
                    "OUTLET",
                    context,
                    cardWidth: MediaQuery.of(context).size.width,
                    cardHeight: 120,
                    imageWidth: 80,
                    imageHeight: 80,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPaymentMethodCard(String imagePath, String bankCode,
      String bankName, String typePayment, context,
      {required double cardWidth,
      required double cardHeight,
      required double imageWidth,
      required double imageHeight}) {
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
                "total_payment": total!.replaceAll(",", ""),
                "status": "activation"
              },
              options: Options(headers: {
                "Content-Type": "application/json",
                "Authorization": "Bearer $token"
              }),
            );

            if (response3.statusCode == 200) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (builder) => InvoicePage(
                    taskid: widget.taskid ?? "",
                    bankName: bankName ?? "",
                    total: total ?? "0",
                    typePayment: typePayment ?? "",
                  ),
                ),
              );
            }
          } catch (e) {
            print(e.toString());
          }
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
