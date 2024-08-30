import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: PenawaranPage(),
  ));
}

class PenawaranPage extends StatelessWidget {
  const PenawaranPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Lihat Semua',
            style: TextStyle(fontSize: 16),
          ),
          centerTitle: true,
        ),
      ),
    );
  }
}
