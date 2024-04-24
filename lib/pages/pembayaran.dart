import 'package:flutter/material.dart';

class PaymentPage extends StatelessWidget {
  const PaymentPage({super.key});

  Future<void> getPaymentMethod() async {}

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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8.0),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Pesanan:'),
                  Text(
                    'Rp 179.000',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Pajak:'),
                  Text(
                    '11%',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total:'),
                  Text(
                    'Rp 198.169',
                    style: TextStyle(fontWeight: FontWeight.bold),
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
              buildPaymentMethodCard('images/bank/bca.png', 'Bank BCA', context,
                  cardWidth: MediaQuery.of(context).size.width,
                  cardHeight: 120,
                  imageWidth: 50,
                  imageHeight: 50),
              buildPaymentMethodCard(
                  'images/bank/mandiri.png', 'Bank Mandiri', context,
                  cardWidth: MediaQuery.of(context).size.width,
                  cardHeight: 120,
                  imageWidth: 50,
                  imageHeight: 50),
              buildPaymentMethodCard('images/bank/bni.png', 'Bank BNI', context,
                  cardWidth: MediaQuery.of(context).size.width,
                  cardHeight: 120,
                  imageWidth: 50,
                  imageHeight: 50),
              buildPaymentMethodCard('images/bank/bri.png', 'Bank BRI', context,
                  cardWidth: MediaQuery.of(context).size.width,
                  cardHeight: 120,
                  imageWidth: 50,
                  imageHeight: 50),
              buildPaymentMethodCard('images/bank/BSI.png', 'Bank BSI', context,
                  cardWidth: MediaQuery.of(context).size.width,
                  cardHeight: 120,
                  imageWidth: 50,
                  imageHeight: 50),
              buildPaymentMethodCard(
                  'images/bank/permata.png', 'Bank Permata', context,
                  cardWidth: MediaQuery.of(context).size.width,
                  cardHeight: 120,
                  imageWidth: 50,
                  imageHeight: 50),
              buildPaymentMethodCard(
                  'images/bank/cimb.png', 'Bank CIMB', context,
                  cardWidth: MediaQuery.of(context).size.width,
                  cardHeight: 120,
                  imageWidth: 50,
                  imageHeight: 50),
              buildPaymentMethodCard('images/bank/DBS.png', 'Bank DBS', context,
                  cardWidth: MediaQuery.of(context).size.width,
                  cardHeight: 120,
                  imageWidth: 50,
                  imageHeight: 50),
              buildPaymentMethodCard('images/bank/BJB.png', 'Bank BJB', context,
                  cardWidth: MediaQuery.of(context).size.width,
                  cardHeight: 120,
                  imageWidth: 50,
                  imageHeight: 50),
              buildPaymentMethodCard(
                  'images/bank/sampoerna.png', 'Bank Sampoerna', context,
                  cardWidth: MediaQuery.of(context).size.width,
                  cardHeight: 120,
                  imageWidth: 50,
                  imageHeight: 50),
              buildPaymentMethodCard(
                  'images/bank/alfamart.png', 'Alfamart', context,
                  cardWidth: MediaQuery.of(context).size.width,
                  cardHeight: 120,
                  imageWidth: 50,
                  imageHeight: 50),
              buildPaymentMethodCard(
                  'images/bank/indomart.png', 'Indomart', context,
                  cardWidth: MediaQuery.of(context).size.width,
                  cardHeight: 120,
                  imageWidth: 50,
                  imageHeight: 50),
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
