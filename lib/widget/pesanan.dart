import 'package:flutter/material.dart';
import 'package:idmall/pages/pembayaran.dart'; // Mengimport halaman pembayaran

class OrderPage extends StatelessWidget {
  const OrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
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
              margin: const EdgeInsets.symmetric(vertical: 16.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.asset(
                            'images/promo1.png',
                            width: 150.0, // Besarkan ukuran gambar
                            height: 150.0, // Besarkan ukuran gambar
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 8.0),
                            Text(
                              'Nama Produk',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4.0),
                            Text(
                              'Rp. 100.000',
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: 4.0),
                            Text(
                              'Up to 10% off',
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.orange,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.local_offer,
                              color: Colors.black,
                            ),
                            SizedBox(width: 8.0),
                            Text(
                              'Masukkan Kupon',
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'Pilih',
                          style: TextStyle(
                            fontSize: 12.0,
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    const Divider(),
                    const SizedBox(height: 20.0),
                    const Text(
                      'Detail Pembayaran',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Pembayaran:',
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                        Text(
                          'Rp 179.000',
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Pajak:',
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                        Text(
                          '11%',
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    const Row(
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
                    const Divider(),
                    const SizedBox(height: 8.0),
                    const Row(
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
                          'Rp 198.690',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigasi ke halaman pembayaran saat tombol ditekan
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const PaymentPage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.orange, // Warna background orange
                          // Warna text putih
                          padding: const EdgeInsets.symmetric(
                              vertical: 16.0), // Padding tambahan
                        ),
                        child: const Text('Proses Pembayaran'),
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
