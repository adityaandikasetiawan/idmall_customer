import 'package:flutter/material.dart';

class ChatbotPage extends StatelessWidget {
  const ChatbotPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 43, 166, 228),
        title: const Text('Chatbot'),
      ),
      body: const Center(
        child: Text('Ini adalah halaman Chatbot'),
      ),
    );
  }
}
