import 'package:flutter/material.dart';

import 'package:dio/dio.dart';
import 'package:idmall/models/payment_method.dart';
import 'package:idmall/models/payment_method_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:idmall/config/config.dart' as config;

class PaymentMethod extends StatefulWidget {
  const PaymentMethod({super.key});

  @override
  State<PaymentMethod> createState() => _PaymentMethodState();
}

class _PaymentMethodState extends State<PaymentMethod> {
  @override
  void initState() {
    super.initState();
    getPaymentMethod();
  }

  List<PaymentMethodModel> paymentMethodListBank = [];
  List<PaymentMethodModelOutlet> paymentMethodListOutlet = [];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
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
              SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Pesanan:'),
                  Text(
                    'Rp 179.000',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Pajak:'),
                  Text(
                    '11%',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total:'),
                  Text(
                    'Rp 198.169',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              Divider(),
              SizedBox(height: 8.0),
              Text(
                'Metode Pembayaran:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20.0),
              ListView.builder(
                shrinkWrap: true,
                itemCount: paymentMethodListBank.length,
                itemBuilder: (context, index) {
                  return buildPaymentMethodCard(
                    paymentMethodListBank[index].iconURL,
                    paymentMethodListBank[index].name,
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
                    paymentMethodListOutlet[index].name,
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

  Widget buildPaymentMethodCard(String imagePath, String bankName, context,
      {required double cardWidth,
      required double cardHeight,
      required double imageWidth,
      required double imageHeight}) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () {
          // Logika untuk metode pembayaran tertentu
          // Navigator.of(context).push(MaterialPageRoute(builder: (builder) =>  Invoice(code: bankName,)));
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
                SizedBox(
                  width: 100,
                ),
                Expanded(
                  child: Text(
                    bankName,
                    style: TextStyle(
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
