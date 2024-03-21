import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  final String title;
  final String price;
  final String imagePath;

  const DetailPage({
    Key? key,
    required this.title,
    required this.price,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            imagePath,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  price,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Deskripsi Produk:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Tambahkan deskripsi produk di sini...',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
  style: ElevatedButton.styleFrom(
    shadowColor: Colors.orange, // Ubah warna latar belakang tombol menjadi orange
    backgroundColor: Colors.white, // Ubah warna font menjadi putih
    side: BorderSide(color: Colors.orange), // Tambahkan garis tepi dengan warna yang sama
  ),
  onPressed: () {
    // Tambahkan logika untuk memasukkan produk ke keranjang di sini
    // Misalnya, Anda dapat menampilkan pesan atau mengirimkan produk ke keranjang belanja
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Sukses'),
        content: Text('Produk berhasil dimasukkan ke keranjang.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Tutup'),
          ),
        ],
      ),
    );
  },
  child: Text('Tambah ke Keranjang'),
),

                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
