import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/material.dart';
import 'package:idmall/consts.dart';
import 'package:idmall/pages/payment_to.dart';
import 'package:idmall/pages/pembayaran.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Mengimport halaman pembayaran

class OrderData extends StatefulWidget {
  final String taskID;
  const OrderData({super.key, required this.taskID});

  @override
  State<OrderData> createState() => _OrderDataState();
}

class _OrderDataState extends State<OrderData> {
  String? namaProduk;
  String? token;
  int? price;
  double ppn = 11;
  int? totalPrice;
  Dio dio = Dio();

  Future getDataTaskID (taskID) async {

    SharedPreferences _pref = await SharedPreferences.getInstance();
    setState(() {
      token = _pref.getString('token');
    });

    print(taskID);
    

    
    (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () =>
        HttpClient()
          ..badCertificateCallback =
              (X509Certificate cert, String host, int port) => true;
    var response = await dio.get("$linkLaravelAPI/customer/fab",
        queryParameters: {"taskID": taskID},
        options: Options(headers: {
          HttpHeaders.authorizationHeader: token,
        }));
    var hasil = response.data;
    if (hasil['status'] == 'success') {
      var tempPrice;
      setState(() {
        namaProduk =  hasil['data']['serviceName'];
        price =  hasil['data']['price'];
        tempPrice = (price! * ppn / 100) + price!;
        totalPrice = tempPrice.round();
      });
      
    }else {
      print(hasil);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataTaskID(widget.taskID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pesanan',
          style: TextStyle(fontSize: 16.0), // Ubah ukuran font menjadi 16px
        ),
        centerTitle: true, // Posisikan judul ke tengah
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 0.0, // Hilangkan elevation agar tidak ada shadow
              margin: EdgeInsets.symmetric(vertical: 16.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.asset(
                              'images/promo1.png',
                              width: 150.0, // Besarkan ukuran gambar
                              height: 150.0, // Besarkan ukuran gambar
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(width: 16.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 8.0),
                              Text(
                                namaProduk ?? 'Produk',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4.0),
                              Text(
                                'Rp. $price',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.grey,
                                ),
                              ),
                              // SizedBox(height: 4.0),
                              // Text(
                              //   'Up to 10% off',
                              //   style: TextStyle(
                              //     fontSize: 14.0,
                              //     color: Colors.orange,
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.0),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Row(
                    //       children: [
                    //         Icon(
                    //           Icons.local_offer,
                    //           color: Colors.black,
                    //         ),
                    //         SizedBox(width: 8.0),
                    //         Text(
                    //           'Masukkan Kupon',
                    //           style: TextStyle(
                    //             fontSize: 18.0,
                    //             color: Colors.black,
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //     Text(
                    //       'Pilih',
                    //       style: TextStyle(
                    //         fontSize: 12.0,
                    //         color: Colors.orange,
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    SizedBox(height: 20.0),
                    Divider(),
                    SizedBox(height: 20.0),
                    Text(
                      'Detail Pembayaran',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Pembayaran:',
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                        Text(
                          'Rp $price',
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Pajak:',
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                        Text(
                          '$ppn%',
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Biaya Pemasangan:',
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                        Text(
                          'Gratis',
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                    SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Pemesanan:',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Rp $totalPrice',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.0),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigasi ke halaman pembayaran saat tombol ditekan
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => PaymentToPage(totalPrice: totalPrice, taskID: widget.taskID, ppn: ppn,)),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange, // Warna background orange
                          // Warna text putih
                          padding: EdgeInsets.symmetric(vertical: 16.0), // Padding tambahan
                        ),
                        child: Text('Proses Pembayaran'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
