import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: PackagesPage(),
  ));
}

class PackagesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Paket',
            style: TextStyle(fontSize: 16),
          ),
          centerTitle: true,
        ),
       
      ),
    );
  }
}

