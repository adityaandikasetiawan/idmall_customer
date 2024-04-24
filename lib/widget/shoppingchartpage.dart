import 'package:flutter/material.dart';
import 'package:idmall/widget/pesanan.dart'; // Import halaman OrderPage

class ShoppingCartPage extends StatelessWidget {
  const ShoppingCartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Keranjang Belanja',
          style: TextStyle(fontSize: 16.0), // Ubah ukuran font menjadi 16px
        ),
        centerTitle: true, // Posisikan judul ke tengah
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.location_on),
                SizedBox(width: 16.0),
                Text(
                  'Alamat Anda',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    height: 120.0,
                    child: Card(
                      elevation: 4.0,
                      margin: const EdgeInsets.only(right: 8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Alamat Lengkap',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    // Tambahkan logika untuk mengedit alamat
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 8.0),
                            const Text(
                              'Jl. Contoh No. 123, Kota Contoh',
                              style: TextStyle(fontSize: 14.0),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    height: 120.0,
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 200.0),
                      child: Card(
                        elevation: 4.0,
                        margin: const EdgeInsets.only(left: 8.0),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Center(
                                  child: Image.asset(
                                    'images/widget/add.png',
                                    width: 50.0,
                                    height: 50.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            const Text(
              'List Pembelian',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            GestureDetector(
              // Tambahkan GestureDetector di sini
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const OrderPage(),
                  ),
                );
              },
              child: Card(
                elevation: 4.0,
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
                              width: 80.0,
                              height: 80.0,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 16.0),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Nama Produk',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4.0),
                                Text(
                                  'Rp. 100.000',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.grey,
                                  ),
                                ),
                                SizedBox(height: 4.0),
                                Text(
                                  'Up to 10% off',
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    color: Colors.orange,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Pembayaran',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Rp. 90.000',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
