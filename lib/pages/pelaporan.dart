import 'package:flutter/material.dart';

class PelaporanPage extends StatelessWidget {
  const PelaporanPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pelaporan'),
      ),
      body: const Center(
        child: Text(
          'Halaman Pelaporan',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
