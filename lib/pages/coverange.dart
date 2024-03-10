import 'package:flutter/material.dart';

class CoveragePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cek Coverage'),
      ),
      body: Center(
        child: Text(
          'Ini adalah halaman Cek Coverage',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: CoveragePage(),
  ));
}
