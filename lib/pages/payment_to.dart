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
  const PaymentToPage({super.key, required this.totalPrice, required this.taskID, required this.ppn});

  @override
  State<PaymentToPage> createState() => _PaymentToPageState();
}

class _PaymentToPageState extends State<PaymentToPage> {
  Dio dio = Dio();
  String? token;
  
  Future<List<Map<String,dynamic>>>? list;


  Future<List<Map<String,dynamic>>> getPaymentList() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    setState(() {
      token = _pref.getString('token');
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
      List<Map<String,dynamic>> list = [];
      List list1 = [];
      hasil['data'].forEach((key, ele) {
          list.add({
            key: ele
          });
        // for (var elem in ele) {
        //   // elem.forEach((keys, eleme) {
        //   // });
        // }
      });
      print(list[1]);
      return list;
      
    }else {
      return List.empty();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    list = getPaymentList();
  }

  @override
  Widget build(BuildContext context) {
    var price = (widget.totalPrice!/1.11).round();
    return Scaffold(
      appBar: AppBar(
        title: Text(
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
              SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Pesanan:'),
                  Text(
                    'Rp $price',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Pajak:'),
                  Text(
                    '${widget.ppn}%',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total:'),
                  Text(
                    'Rp ${widget.totalPrice}',
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
              // SizedBox(
              //   child: FutureBuilder(
              //     future: list,
              //     builder: (context, snapshot) {
              //       snapshot.connectionState == ConnectionState.done
              //             ? print(snapshot)
              //             : print('loading');
              //       if (snapshot.connectionState == ConnectionState.waiting) {
              //         return CircularProgressIndicator();
              //       }else
              //       if (snapshot.hasData) {
              //         final List<Map<String,dynamic>> dataNya = snapshot.data!;
              //         print(snapshot.data!);
              //         return ListView.builder(
              //           shrinkWrap: true,
              //           primary: false,
              //           physics: NeverScrollableScrollPhysics(),
              //           itemCount: dataNya.length,
              //           itemBuilder: (context, index) {
              //             var dataNya1 = dataNya[index];
              //             return ListView.builder(
              //               shrinkWrap: true,
              //               primary: false,
              //               physics: NeverScrollableScrollPhysics(),
              //               itemBuilder: (context, index1) {
              //                 print(dataNya1);
              //                 return buildPaymentNew('images/bank/bca.png', dataNya1['name'] ?? '', context, dataNya1['code'] ?? '');
              //               },
              //             );
              //             // buildPaymentMethodCard('images/bank/bca.png', snapshot.data['name'], context, cardWidth: MediaQuery.of(context).size.width, cardHeight: 120, imageWidth: 50, imageHeight: 50);
              //           },
              //         );
              //       }else {
              //         return Text('no data available');
              //       }
              //     }
              //   ),
              // ),
              // getPaymentList(context) ?? Container(),
              buildPaymentMethodCard('images/bank/bca.png', 'Bank BCA', context, cardWidth: MediaQuery.of(context).size.width, cardHeight: 120, imageWidth: 50, imageHeight: 50),
              buildPaymentMethodCard('images/bank/mandiri.png', 'Bank Mandiri', context, cardWidth: MediaQuery.of(context).size.width, cardHeight: 120, imageWidth: 50, imageHeight: 50),
              buildPaymentMethodCard('images/bank/bni.png', 'Bank BNI', context, cardWidth: MediaQuery.of(context).size.width, cardHeight: 120, imageWidth: 50, imageHeight: 50),
              buildPaymentMethodCard('images/bank/bri.png', 'Bank BRI', context, cardWidth: MediaQuery.of(context).size.width, cardHeight: 120, imageWidth: 50, imageHeight: 50),
              buildPaymentMethodCard('images/bank/BSI.png', 'Bank BSI', context, cardWidth: MediaQuery.of(context).size.width, cardHeight: 120, imageWidth: 50, imageHeight: 50),
              buildPaymentMethodCard('images/bank/permata.png', 'Bank Permata', context, cardWidth: MediaQuery.of(context).size.width, cardHeight: 120, imageWidth: 50, imageHeight: 50),
              buildPaymentMethodCard('images/bank/cimb.png', 'Bank CIMB', context, cardWidth: MediaQuery.of(context).size.width, cardHeight: 120, imageWidth: 50, imageHeight: 50),
              buildPaymentMethodCard('images/bank/DBS.png', 'Bank DBS', context, cardWidth: MediaQuery.of(context).size.width, cardHeight: 120, imageWidth: 50, imageHeight: 50),
              buildPaymentMethodCard('images/bank/BJB.png', 'Bank BJB', context, cardWidth: MediaQuery.of(context).size.width, cardHeight: 120, imageWidth: 50, imageHeight: 50),
              buildPaymentMethodCard('images/bank/sampoerna.png', 'Bank Sampoerna', context, cardWidth: MediaQuery.of(context).size.width, cardHeight: 120, imageWidth: 50, imageHeight: 50),
              buildPaymentMethodCard('images/bank/alfamart.png', 'Alfamart', context, cardWidth: MediaQuery.of(context).size.width, cardHeight: 120, imageWidth: 50, imageHeight: 50),
              buildPaymentMethodCard('images/bank/indomart.png', 'Indomart', context, cardWidth: MediaQuery.of(context).size.width, cardHeight: 120, imageWidth: 50, imageHeight: 50),
              // SizedBox(height: 20.0),
              // SizedBox(
              //   width: double.infinity,
              //   child: ElevatedButton(
              //     onPressed: () {
              //       // Logika untuk lanjutkan pembayaran
              //     },
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor: Colors.orange,
              //     ),
              //     child: Text('Lanjutkan'),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPaymentNew(String imagePath, String bankName, context, String code) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () {
          // Logika untuk metode pembayaran tertentu
          Navigator.of(context).push(MaterialPageRoute(builder: (builder) =>  Invoice(code: code,)));
        },
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 150,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Image.asset(
                    imagePath,
                    width: 50,
                    height: 50,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(width: 100,),
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

  Widget buildPaymentMethodCard(String imagePath, String bankName, context, {required double cardWidth, required double cardHeight, required double imageWidth, required double imageHeight}) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () {
          // Logika untuk metode pembayaran tertentu
          Navigator.of(context).push(MaterialPageRoute(builder: (builder) =>  Invoice(code: bankName,)));
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
                SizedBox(width: 100,),
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
