import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: TextStyle(fontSize: 16), // Ubah ukuran teks judul
        ),
        centerTitle: true, // Menjadikan judul app bar berada di tengah
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Navigasi ke halaman Promosi saat tombol Promosi ditekan
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PromotionsPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 55, vertical: 10), // Ubah ukuran padding tombol
                ),
                child: Text('Promosi'),
              ),
              SizedBox(width: 20), // Tambahkan jarak horizontal antara tombol
              ElevatedButton(
                onPressed: () {
                  // Navigasi ke halaman Status Bar saat tombol Status Bar ditekan
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => StatusBarPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 55, vertical: 10), // Ubah ukuran padding tombol
                ),
                child: Text('Status Bar'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


class PromotionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Promotions'),
      ),
      body: Center(
        child: Text('Ini adalah halaman Promosi'),
      ),
    );
  }
}

class StatusBarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Status Bar'),
      ),
      body: Center(
        child: Text('Ini adalah halaman Status Bar'),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: NotificationsPage(),
  ));
}
