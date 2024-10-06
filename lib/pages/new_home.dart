import 'package:flutter/material.dart';

class NewHomeScreen extends StatefulWidget {
  const NewHomeScreen({super.key});

  @override
  State<NewHomeScreen> createState() => _NewHomeScreenState();
}

class _NewHomeScreenState extends State<NewHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Nama Lengkap"),
            Text("270 poin"),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.mail),
            onPressed: () {},
          ),
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                Color(0xFFFFC107), // Ganti warna sesuai keinginan
                Color(0xFFFFA000), // Ganti warna sesuai keinginan
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 900,
              child: Stack(
                alignment: Alignment.topLeft,
                children: [
                  Image.asset(
                    'images/dashboard_bg_1.png',
                    // width: 50,
                    // height: 153,
                    fit: BoxFit.cover, // Agar gambar sesuai
                  ),
                  // Gambar kedua
                  Image.asset(
                    'images/dashboard_bg_2.png',
                    width: 900,
                    // height: 253,
                    // fit: BoxFit.cover, // Agar gambar sesuai
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
