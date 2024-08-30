import 'package:flutter/material.dart';
import 'package:idmall/pages/bantuan/pertanyaan.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MaterialApp(
    home: Bantuan(),
  ));
}

class Bantuan extends StatelessWidget {
  const Bantuan({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height * 1.5;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
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
              'Mempunyai masalah dengan layanan? Adukan ke WhatsApp kami!',
              _launchWhatsApp,
            ),
            const SizedBox(height: 16), // Spasi antara kedua Card
            buildCard(
              screenHeight,
              'LIHAT PERTANYAAN',
              'images/splash.png',
              'Punya pertanyaan seputar produk kami? lihat FAQ kami!',
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PertanyaanPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _launchWhatsApp() async {
    const phoneNumber = '+628127000124'; // Ganti dengan nomor tujuan
    const message =
        'Hello, this is a test message.'; // Pesan yang ingin dikirim
    final Uri whatsappUrl = Uri.parse(
        'whatsapp://send?phone=$phoneNumber&text=${Uri.encodeComponent(message)}'); // Skema URI WhatsApp

    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(whatsappUrl);
    } else {
      final Uri fallbackUrl = Uri.parse(
          'https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}');
      if (await canLaunchUrl(fallbackUrl)) {
        await launchUrl(fallbackUrl);
      } else {
        throw 'Could not launch $whatsappUrl or $fallbackUrl';
      }
    }
  }

  Widget buildCard(
    double screenHeight,
    String buttonText,
    String imagePath,
    String textDescription,
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
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(0.5), // Efek blur
              spreadRadius: 2,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Kolom pertama: Gambar
            SizedBox(
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
                  const SizedBox(height: 8),
                  Text(
                    '${textDescription}',
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                  const SizedBox(height: 16),
                  // Teks button (pengaduan layanan atau lihat pertanyaan) dengan border
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: onPressed,
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        backgroundColor: Colors.transparent,
                        side: const BorderSide(color: Colors.orange, width: 2),
                      ),
                        child: Text(
                          buttonText,
                          style: const TextStyle(
                            fontSize: 12,
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
