import 'package:flutter/material.dart';

class PelaporanPage extends StatelessWidget {
  const PelaporanPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pelaporan',
          style: TextStyle(fontSize: 16), // Mengatur ukuran teks menjadi 16
        ),
        centerTitle: true, // Menengahkan judul
      ),
      body: Center(
        child: Text(
          'Halaman Pelaporan',
          style: TextStyle(fontSize: 24), // Contoh ukuran teks untuk halaman
        ),
      ),
    );
  }
}

