import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Jumlah tab
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Notifications',
            style: TextStyle(fontSize: 16),
          ),
          centerTitle: true,
          bottom: TabBar( // Menambahkan TabBar di bawah judul app bar
            tabs: [
              Tab(text: 'Promosi'), // Tab pertama dengan teks 'Promosi'
              Tab(text: 'Status Bar'), // Tab kedua dengan teks 'Status Bar'
            ],
          ),
        ),
        body: TabBarView( // Menampilkan konten sesuai dengan tab yang dipilih
          children: [
            PromotionsPage(data: 'Ini adalah halaman Promosi'), // Konten untuk tab 'Promosi'
            StatusBarPage(data: 'Ini adalah halaman Status Bar'), // Konten untuk tab 'Status Bar'
          ],
        ),
      ),
    );
  }
}

class PromotionsPage extends StatelessWidget {
  final String data;

  PromotionsPage({required this.data});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(data),
    );
  }
}

class StatusBarPage extends StatelessWidget {
  final String data;

  StatusBarPage({required this.data});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(data),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: NotificationsPage(),
  ));
}
