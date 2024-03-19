import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: PenawaranPage(),
  ));
}

class PenawaranPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Lihat Semua',
            style: TextStyle(fontSize: 16),
          ),
          centerTitle: true,
        ),
       
      ),
    );
  }
}


