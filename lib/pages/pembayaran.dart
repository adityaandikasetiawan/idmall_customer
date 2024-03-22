import 'package:flutter/material.dart';

class PaymentPage extends StatelessWidget {
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
              buildPaymentMethodCard('images/bank/bca.png', 'Bank BCA', cardWidth: 500, cardHeight: 120, imageWidth: 100, imageHeight: 50),
              buildPaymentMethodCard('images/bank/mandiri.png', 'Bank Mandiri', cardWidth: 500, cardHeight: 120, imageWidth: 100, imageHeight: 50),
              buildPaymentMethodCard('images/bank/bni.png', 'Bank BNI', cardWidth: 500, cardHeight: 120, imageWidth: 100, imageHeight: 50),
              buildPaymentMethodCard('images/bank/bri.png', 'Bank BRI', cardWidth: 500, cardHeight: 120, imageWidth: 100, imageHeight: 50),
              buildPaymentMethodCard('images/bank/BSI.png', 'Bank BSI', cardWidth: 500, cardHeight: 120, imageWidth: 100, imageHeight: 50),
              buildPaymentMethodCard('images/bank/permata.png', 'Bank Permata', cardWidth: 500, cardHeight: 120, imageWidth: 100, imageHeight: 50),
              buildPaymentMethodCard('images/bank/cimb.png', 'Bank CIMB', cardWidth: 500, cardHeight: 120, imageWidth: 100, imageHeight: 50),
              buildPaymentMethodCard('images/bank/DBS.png', 'Bank DBS', cardWidth: 500, cardHeight: 120, imageWidth: 100, imageHeight: 50),
              buildPaymentMethodCard('images/bank/BJB.png', 'Bank BJB', cardWidth: 500, cardHeight: 120, imageWidth: 100, imageHeight: 50),
              buildPaymentMethodCard('images/bank/sampoerna.png', 'Bank Sampoerna', cardWidth: 500, cardHeight: 120, imageWidth: 100, imageHeight: 50),
              buildPaymentMethodCard('images/bank/alfamart.png', 'Alfamart', cardWidth: 500, cardHeight: 120, imageWidth: 100, imageHeight: 50),
              buildPaymentMethodCard('images/bank/indomart.png', 'Indomart', cardWidth: 500, cardHeight: 120, imageWidth: 100, imageHeight: 50),
              SizedBox(height: 20.0),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Logika untuk lanjutkan pembayaran
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                  ),
                  child: Text('Lanjutkan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPaymentMethodCard(String imagePath, String bankName, {required double cardWidth, required double cardHeight, required double imageWidth, required double imageHeight}) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () {
          // Logika untuk metode pembayaran tertentu
        },
        child: SizedBox(
          width: cardWidth,
          height: cardHeight,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Image.asset(
                  imagePath,
                  width: imageWidth,
                  height: imageHeight,
                  fit: BoxFit.contain,
                ),               
                SizedBox(width: 140.0), // Spacer untuk jarak antara gambar dan teks
                Text(
                  bankName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
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
