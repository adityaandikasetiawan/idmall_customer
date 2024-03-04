import 'package:flutter/material.dart';

class ChatbotPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 43, 166, 228),
        title: Text('Chatbot'),
      ),
      body: Center(
        child: Text('Ini adalah halaman Chatbot'),
      ),
    );
  }
}
