import 'package:flutter/material.dart';

class CardWidgetWithIcon extends StatelessWidget {
  final IconData icon;
  final String text;
  final String value;

  const CardWidgetWithIcon(
      {super.key, required this.icon, required this.text, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.white), // Ubah warna ikon menjadi putih
            const SizedBox(width: 8),
            Text(
              text,
              style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white), // Ubah warna teks menjadi putih
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
              fontSize: 20,
              color: Colors.white, // Ubah warna nilai (value) menjadi putih
              fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
