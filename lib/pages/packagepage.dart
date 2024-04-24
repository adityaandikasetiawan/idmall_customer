import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: PackagesPage(),
  ));
}

class PackagesPage extends StatelessWidget {
  const PackagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Paket',
            style: TextStyle(fontSize: 16),
          ),
          centerTitle: true,
        ),
      ),
    );
  }
}
