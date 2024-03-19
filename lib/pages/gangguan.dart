import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: TroublePage(),
  ));
}

class TroublePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Gangguan',
            style: TextStyle(fontSize: 16),
          ),
          centerTitle: true,
        ),
       
      ),
    );
  }
}

