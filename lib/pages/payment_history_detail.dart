import 'package:flutter/material.dart';

class PaymentHistoryDetail extends StatefulWidget {
  const PaymentHistoryDetail({super.key});

  @override
  State<PaymentHistoryDetail> createState() => _PaymentHistoryDetailState();
}

class _PaymentHistoryDetailState extends State<PaymentHistoryDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Transaksi"),
      ),
      body: Column(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("No Transaksi"),
                Text("092827721"),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Status Tagihan"),
                Text("Lunas"),
              ],
            ),
          ),
          Divider(),
          SizedBox(
            height: 10,
          ),
          const Text(
            "Detail Tagihan",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 20,
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Nama Paket"),
                Text("Lunas"),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Biaya"),
                Text("Lunas"),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("PPN(11%)"),
                Text("Lunas"),
              ],
            ),
          ),
          Divider(),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Total"),
                Text("Lunas"),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          const Text("Metode Pembayaran"),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Total"),
                Text("Lunas"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
