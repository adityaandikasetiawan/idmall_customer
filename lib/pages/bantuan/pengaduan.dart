// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: PengaduanPage(),
  ));
}

class PengaduanPage extends StatefulWidget {
  const PengaduanPage({super.key});

  @override
  _PengaduanPageState createState() => _PengaduanPageState();
}

class _PengaduanPageState extends State<PengaduanPage> {
  String dropdownValue = 'Gangguan 1'; // Default dropdown value
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pengaduan Page',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'Mohon maaf atas ketidaknyamanannya. Mohon laporkan masalah atau gangguan tersebut di sini agar Kami dapat segera menindaklanjutinya.',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            const Text(
              'Gangguan Yang di Alami Kami',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            const SizedBox(height: 8),
            DropdownButton<String>(
              value: dropdownValue,
              icon: const Icon(Icons.arrow_drop_down, color: Colors.orange),
              iconSize: 24,
              elevation: 16,
              isExpanded: true,
              underline: Container(
                height: 2,
                color: Colors.orange,
              ),
              onChanged: (String? newValue) {
                setState(() {
                  dropdownValue = newValue!;
                });
              },
              items: <String>[
                'Gangguan 1',
                'Gangguan 2',
                'Gangguan 3',
                'Gangguan 4'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            const Text(
              'KOMENTAR/MASUKAN ANDA',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            const SizedBox(height: 8),
            TextFormField(
              maxLines: 5,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10),
                ),
                hintText: 'Tulis komentar atau masukan Anda di sini...',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Tambahkan logika untuk mengirim laporan gangguan
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Laporkan Gangguan'),
            ),
          ],
        ),
      ),
    );
  }
}
