import 'dart:async';
import 'package:flutter/material.dart';
import 'package:idmall/pages/navigation.dart';
import 'package:intl/intl.dart';

class InvoicePage extends StatefulWidget {
  final String taskid;
  final String bankName;
  final String typePayment;
  final String total;
  const InvoicePage({
    super.key,
    required this.taskid,
    required this.bankName,
    required this.total,
    required this.typePayment,
  });

  @override
  _InvoicePageState createState() => _InvoicePageState();
}

class _InvoicePageState extends State<InvoicePage> {
  // Waktu countdown
  late Timer _timer;
  int _secondsRemaining = 86400; // 24 jam dalam detik
  final oCcy = new NumberFormat("#,##0", "en_US");

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void startTimer() {
    const oneSecond = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSecond,
      (timer) {
        setState(() {
          if (_secondsRemaining > 0) {
            _secondsRemaining--;
          } else {
            _timer.cancel();
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invoice'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Detail Pembayaran',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  ListTile(
                    title: Text('Metode Pembayaran'),
                    subtitle: Text(widget.typePayment == "BANK"
                        ? "Virtual Account"
                        : "Outlet"),
                  ),
                  ListTile(
                    title: Text('Bank'),
                    subtitle: Text(widget.bankName),
                  ),
                  ListTile(
                    title: Text('Nomor Rekening'),
                    subtitle: Text(widget.taskid),
                  ),
                  ListTile(
                    title: Text('Total Pembayaran'),
                    subtitle: Text('Rp. ${widget.total}'),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Tata Cara Pembayaran',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '1. Lakukan transfer sejumlah total pembayaran ke rekening yang tertera.',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: 8),
                      Text(
                        '2. Sertakan nomor invoice pada deskripsi transfer.',
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: 8),
                      Text(
                        '3. Setelah melakukan pembayaran, tunggu hingga konfirmasi pembayaran diterima.',
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.left,
                      )
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Waktu Pembayaran Tersisa:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '${(_secondsRemaining ~/ 3600).toString().padLeft(2, '0')} : ${((_secondsRemaining % 3600) ~/ 60).toString().padLeft(2, '0')} : ${(_secondsRemaining % 60).toString().padLeft(2, '0')}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  // ElevatedButton(
                  //   onPressed: () {},
                  //   child: Text("Batalkan Pembayaran"),
                  // ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (builder) => NavigationScreen(),
                        ),
                      );
                    },
                    child: Text("Kembali ke beranda"),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
