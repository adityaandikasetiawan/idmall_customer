// ignore_for_file: non_constant_identifier_names, empty_catches

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:idmall/models/payment_method.dart';
import 'package:idmall/models/payment_method_model.dart';
import 'package:idmall/pages/invoice_testing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:idmall/config/config.dart' as config;
import 'package:intl/intl.dart';

class HistoryPaymentDetail extends StatefulWidget {
  final String taskid;
  final String periode;
  const HistoryPaymentDetail({
    super.key,
    required this.taskid,
    required this.periode,
  });

  @override
  State<HistoryPaymentDetail> createState() => _PaymentMethodExistingState();
}

class _PaymentMethodExistingState extends State<HistoryPaymentDetail> {
  @override
  void initState() {
    super.initState();
    getPaymentHistoryDetail();
  }

  List<PaymentMethodModel> paymentMethodListBank = [];
  List<PaymentMethodModelOutlet> paymentMethodListOutlet = [];
  final oCcy = NumberFormat("#,##0", "en_US");

  String vat = "";
  String monthly_price = "";
  String total = "";
  String installation_fee = "";
  String paymentDate = "";
  String paymentMethod = "";

  Future<void> getPaymentHistoryDetail() async {
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token') ?? "";
    final dio = Dio();
    final response2 =
        await dio.get("${config.backendBaseUrl}/transaction/history/detail",
            options: Options(
              headers: {
                "Content-Type": "application/json",
                "Authorization": "Bearer $token"
              },
            ),
            data: {
          "task_id": widget.taskid,
          "period": "",
        });
    var result2 = response2.data['data'][0];
    setState(
      () {
        vat = oCcy.format(result2['PPN']).replaceAll(",", ".");
        monthly_price = oCcy.format(result2['Subtotal']);
        total = oCcy.format(result2['Total']);
        installation_fee = result2['Installation'] != null
            ? oCcy.format(result2['Installation']).replaceAll(",", ".")
            : '0';
        paymentDate = result2['Payment_Date'];
        paymentMethod = result2['Payment_Method'];
      },
    );
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Tanggal Pembayaran:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "$paymentDate",
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
                    'Metode Pembayaran:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "$paymentMethod",
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
                    "Terbayar",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Divider(),
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
                "status": "existing"
              },
              options: Options(headers: {
                "Content-Type": "application/json",
                "Authorization": "Bearer $token"
              }),
            );
            String paymentCode = response3.data['data']['payment_code'];

            if (response3.statusCode == 200) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (builder) => InvoicePage(
                    taskid: widget.taskid,
                    bankName: bankName,
                    total: total!,
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
