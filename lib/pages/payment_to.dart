// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/material.dart';
import 'package:idmall/pages/invoice.dart';
import 'package:idmall/config/config.dart' as config;
import 'package:shared_preferences/shared_preferences.dart';

class PaymentToPage extends StatefulWidget {
  final int? totalPrice;
  final String taskID;
  final double ppn;
  const PaymentToPage(
      {super.key,
      required this.totalPrice,
      required this.taskID,
      required this.ppn});

  @override
  State<PaymentToPage> createState() => _PaymentToPageState();
}

class _PaymentToPageState extends State<PaymentToPage> {
  Dio dio = Dio();
  String? token;

  Future<List<Map<String, dynamic>>>? list;

  Future<void> checkPM() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      token = pref.getString('token');
    });
    (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () =>
        HttpClient()
          ..badCertificateCallback =
              (X509Certificate cert, String host, int port) => true;
    var response =
        await dio.get('${config.backendBaseUrl}/transaction/${widget.taskID}',
            // data: dataNya,
            options: Options(headers: {
              HttpHeaders.authorizationHeader: "Bearer $token",
            }));

    // Handle response
    Map<String, dynamic> result = response.data;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (builder) => Invoice(
            code: result['data']['payment_method'],
            totalPrice: result['data']['harga'],
            taskID: widget.taskID),
      ),
    );
  }

  Future<List<Map<String, dynamic>>> getPaymentList() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      token = pref.getString('token');
    });
    (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () =>
        HttpClient()
          ..badCertificateCallback =
              (X509Certificate cert, String host, int port) => true;
    var response = await dio.get("${config.backendBaseUrl}/payment-method/",
        options: Options(headers: {
          HttpHeaders.authorizationHeader: token,
        }));
    var hasil = response.data;
    if (hasil['message'] == 'success') {
      List<Map<String, dynamic>> list = [];
      var data = hasil['data'];
      data.forEach((key, ele) {
        list.add({key: ele});
      });
      return list;
    } else {
      return List.empty();
    }
  }

  Future<void> _submitForm(String taskID, String paymentMethodCode,
      String paymentType, double totalPayment) async {
    var dataNya = {
      'task_id': taskID,
      'payment_method_code': paymentMethodCode,
      'payment_type': paymentType.toUpperCase(),
      'total_payment': totalPayment,
    };
    try {
      // Replace URL with your endpoint
      (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () =>
          HttpClient()
            ..badCertificateCallback =
                (X509Certificate cert, String host, int port) => true;
      var response =
          await dio.post('${config.backendBaseUrl}/transaction/create',
              data: dataNya,
              options: Options(headers: {
                HttpHeaders.authorizationHeader: "Bearer $token",
              }));

      // Handle response
      Map<String, dynamic> result = response.data;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(result['status']),
            content: Text(result['message']),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  // Navigator.of(context).popUntil((route) => route.isFirst);
                  // Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (builder) => Invoice(
                            code: paymentMethodCode,
                            totalPrice: widget.totalPrice!,
                            taskID: widget.taskID,
                          )));
                },
                child: const Text('Close'),
              ),
            ],
          );
        },
      );
      // Navigator.of(context).push(MaterialPageRoute(builder: (builder) => OrderPage()));
    } catch (e) {
      // Handle error
    }
  }

  @override
  void initState() {
    super.initState();
    checkPM();
    list = getPaymentList();
  }

  @override
  Widget build(BuildContext context) {
    var price = (widget.totalPrice! / 1.11).round();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pembayaran',
          style: TextStyle(fontSize: 16.0), // Ubah ukuran font menjadi 16px
        ),
        centerTitle: true, // Posisikan judul ke tengah
      ),
      body: SingleChildScrollView(
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
                    'Rp $price',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Pajak:'),
                  Text(
                    '${widget.ppn}%',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total:'),
                  Text(
                    'Rp ${widget.totalPrice}',
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
              SizedBox(
                child: FutureBuilder(
                    future: list,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasData) {
                        final List<Map<String, dynamic>> dataNya =
                            snapshot.data!;
                        return ListView.builder(
                          shrinkWrap: true,
                          primary: false,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: dataNya.length,
                          itemBuilder: (context, index) {
                            var dataNya1 = index == 0
                                ? dataNya[index]['bank']
                                : dataNya[index]['outlet'];
                            // dataNya1 = dataNya[index];
                            return ListView.builder(
                              shrinkWrap: true,
                              primary: false,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: dataNya1.length,
                              itemBuilder: (context, index1) {
                                return buildPaymentNew(
                                    dataNya1[index1]['icon_url'],
                                    dataNya1[index1]['name'] ?? '',
                                    context,
                                    dataNya1[index1]['code'] ?? '',
                                    index == 0 ? 'bank' : 'outlet');
                              },
                            );
                            // buildPaymentMethodCard('images/bank/bca.png', snapshot.data['name'], context, cardWidth: MediaQuery.of(context).size.width, cardHeight: 120, imageWidth: 50, imageHeight: 50);
                          },
                        );
                      } else {
                        return const Text('no data available');
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPaymentNew(
      String imagePath, String bankName, context, String code, String type) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () async {
          // Logika untuk metode pembayaran tertentu
          await _submitForm(
              widget.taskID, code, type, widget.totalPrice!.toDouble());
        },
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 100,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Image.network(
                    imagePath,
                    width: 50,
                    height: 50,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(
                  width: 50,
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
                  child: Image.asset(
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
