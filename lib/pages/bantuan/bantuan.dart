import 'package:flutter/material.dart';
import 'package:idmall/pages/bantuan/pengaduan.dart';
import 'package:idmall/pages/bantuan/pertanyaan.dart';

void main() {
  runApp(MaterialApp(
    home: Bantuan(),
  ));
}

class Bantuan extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bantuan',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            buildCard(
              screenHeight,
              'PENGADUAN LAYANAN',
              'images/splash.png',
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PengaduanPage()),
                );
              },
            ),
            SizedBox(height: 16), // Spasi antara kedua Card
            buildCard(
              screenHeight,
              'LIHAT PERTANYAAN',
              'images/splash.png',
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PertanyaanPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCard(
    double screenHeight,
    String buttonText,
    String imagePath,
    VoidCallback onPressed,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      color: Colors.white, // Mengubah background color menjadi putih
      child: Container(
        height: screenHeight * 0.2,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(0.5), // Efek blur
              spreadRadius: 2,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Kolom pertama: Gambar
            Container(
              width: 100,
              height: 100,
              child: Center(
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage(imagePath),
                    ),
                  ),
                ),
              ),
            ),
            // Kolom kedua: Deskripsi dan Button
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 8),
                  Text(
                    'Ini adalah deskripsi bantuan yang bisa berisi informasi atau instruksi untuk pengguna.',
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                  SizedBox(height: 16),
                  // Teks button (pengaduan layanan atau lihat pertanyaan) dengan border
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: onPressed,
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        backgroundColor: Colors.transparent,
                        side: BorderSide(color: Colors.orange, width: 2),
                      ),
                      child: Text(
                        buttonText,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


