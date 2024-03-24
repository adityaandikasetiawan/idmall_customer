import 'package:flutter/material.dart';
import 'package:idmall/consts.dart';
import 'package:idmall/pages/details.dart';

class PromoPage extends StatelessWidget {
  // Daftar judul untuk setiap card
  final List<String> titles = [
    'Promo 1',
    'Promo 2',
    'Promo 3',
  ];

  final List<Map<String,dynamic>> cardNya = [
    {
      'title' : 'IdPlay Home 10MB',
      'description' : 'Layanan Rumah Dengan Kecepatan 10MB',
      'image': 'promo1.png',
      'price': 179000,
    },
    {
      'title' : 'IdPlay Home 20MB',
      'description' : 'Layanan Rumah Dengan Kecepatan 20MB',
      'image': 'promo2.png',
      'price': 189000,
    },
    {
      'title' : 'IdPlay Home 30MB',
      'description' : 'Layanan Rumah Dengan Kecepatan 30MB',
      'image': 'promo3.png',
      'price': 199000,
    }
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
        itemCount: cardNya.length, // Ubah jumlah card sesuai kebutuhan
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: PromoCard(
              imagePath: 'images/promo${index + 1}.png', // Panggil gambar promo1.png, promo2.png, dst.
              title: cardNya[index]['title'], // Set judul dari daftar judul sesuai index
              description: cardNya[index]['description'], // Set deskripsi dari daftar deskripsi sesuai index
              price: cardNya[index]['price'].toString(),
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
  final String price;

  const PromoCard({
    required this.imagePath,
    required this.title,
    required this.description,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailPage(
                title: title,
                price: price,
                imagePath: imagePath,
                description: description,
              ),
            ),
          );
      },
      child: Card(
        elevation: 4.0,
        color: Color.fromARGB(200, 19, 24, 84), // Ubah warna latar belakang card
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
                        color: Colors.white, // Ubah warna teks judul
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      description, // Set deskripsi dari properti description
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white, // Ubah warna teks deskripsi
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

void main() {
  runApp(MaterialApp(
    home: PromoPage(),
  ));
}
