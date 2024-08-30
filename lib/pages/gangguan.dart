import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: TroublePage(),
  ));
}

class TroublePage extends StatelessWidget {
  const TroublePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Gangguan',
            style: TextStyle(fontSize: 16),
          ),
          centerTitle: true,
        ),
      ),
    );
  }
}
