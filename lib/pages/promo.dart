import 'package:flutter/material.dart';

class PromoPage extends StatelessWidget {
  // Daftar judul untuk setiap card
  final List<String> titles = [
    'Promo 1',
    'Promo 2',
    'Promo 3',
  ];

  // Daftar deskripsi untuk setiap card
  final List<String> descriptions = [
    'Deskripsi Promo 1',
    'Deskripsi Promo 2',
    'Deskripsi Promo 3',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Promo Page'),
      ),
      body: ListView.builder(
        itemCount: 3, // Ubah jumlah card sesuai kebutuhan
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: PromoCard(
              imagePath: 'images/promo${index + 1}.png', // Panggil gambar promo1.png, promo2.png, dst.
              title: titles[index], // Set judul dari daftar judul sesuai index
              description: descriptions[index], // Set deskripsi dari daftar deskripsi sesuai index
            ),
          );
        },
      ),
    );
  }
}

class PromoCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;

  const PromoCard({
    required this.imagePath,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      color: const Color.fromARGB(255, 255, 255, 255), // Ubah warna latar belakang card
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0), // Rounded corners
                child: Image.asset(
                  imagePath,
                  width: 100, // Sesuaikan ukuran gambar sesuai kebutuhan
                  height: 100, // Sesuaikan ukuran gambar sesuai kebutuhan
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title, // Set judul dari properti title
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 0, 0, 0), // Ubah warna teks judul
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    description, // Set deskripsi dari properti description
                    style: TextStyle(
                      fontSize: 16,
                      color: const Color.fromARGB(255, 0, 0, 0), // Ubah warna teks deskripsi
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: PromoPage(),
  ));
}
