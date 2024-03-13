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
            PromotionsPage(), // Konten untuk tab 'Promosi'
            StatusBarPage(), // Konten untuk tab 'Status Bar'
          ],
        ),
      ),
    );
  }
}

class PromotionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Card pertama
          Card(
            margin: EdgeInsets.all(16.0),
            elevation: 4.0,
            child: ListTile(
              title: Text(
                'Promosi 1',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('Deskripsi Promosi 1'),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                // Tambahkan aksi yang diinginkan saat card ditekan
              },
            ),
          ),
          // Card kedua
          Card(
            margin: EdgeInsets.all(16.0),
            elevation: 4.0,
            child: ListTile(
              title: Text(
                'Promosi 2',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('Deskripsi Promosi 2'),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                // Tambahkan aksi yang diinginkan saat card ditekan
              },
            ),
          ),
          // Card ketiga
          Card(
            margin: EdgeInsets.all(16.0),
            elevation: 4.0,
            child: ListTile(
              title: Text(
                'Promosi 3',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('Deskripsi Promosi 3'),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                // Tambahkan aksi yang diinginkan saat card ditekan
              },
            ),
          ),
          // Card keempat
          Card(
            margin: EdgeInsets.all(16.0),
            elevation: 4.0,
            child: ListTile(
              title: Text(
                'Promosi 4',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('Deskripsi Promosi 4'),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                // Tambahkan aksi yang diinginkan saat card ditekan
              },
            ),
          ),
          // Card kelima
          Card(
            margin: EdgeInsets.all(16.0),
            elevation: 4.0,
            child: ListTile(
              title: Text(
                'Promosi 5',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('Deskripsi Promosi 5'),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                // Tambahkan aksi yang diinginkan saat card ditekan
              },
            ),
          ),
        ],
      ),
    );
  }
}

class StatusBarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Ini adalah halaman Status Bar'),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: NotificationsPage(),
  ));
}
