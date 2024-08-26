import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:idmall/models/payment_history_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:idmall/config/config.dart' as config;
import 'package:intl/intl.dart';

class HistoryPayment extends StatefulWidget {
  const HistoryPayment({super.key});

  @override
  State<HistoryPayment> createState() => _HistoryPaymentState();
}

class _HistoryPaymentState extends State<HistoryPayment> {
  List<PaymentHistoryList> paymentHistory = [];
  final oCcy = NumberFormat("#,##0", "en_US");

  @override
  void initState() {
    super.initState();
    getHistoryPayment();
  }

  Future<void> getHistoryPayment() async {
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token') ?? "";
    final dio = Dio();
    final response = await dio.get(
      "${config.backendBaseUrl}/customer/billing/histories",
      options: Options(headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
        "Cache-Control": "no-cache"
      }),
    );
    for (var ele in response.data['data']) {
      paymentHistory.add(PaymentHistoryList.fromJson(ele));
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            paymentHistory.isNotEmpty
                ? ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: paymentHistory.length,
                    itemBuilder: (context, index) {
                      DateTime dueDate =
                          DateTime.tryParse(paymentHistory[index].periode)!;
                      String formattedDate =
                          DateFormat('MMMM, yyyy').format(dueDate);

                      return Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(
                            border: Border(
                          bottom: BorderSide(
                            color: Colors.grey, // Warna border
                            width: 1.0, // Lebar border
                          ),
                        )),
                        child: ListTile(
                          title: Text(formattedDate),
                          trailing: Text(
                            "Rp. ${oCcy.format(paymentHistory[index].monthlyPrice).toString().replaceAll(",", ".")}",
                          ),
                          onTap: () {},
                        ),
                      );
                    },
                  )
                : const Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Center(
                      child: Text("Tidak ada histori pembayaran"),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
