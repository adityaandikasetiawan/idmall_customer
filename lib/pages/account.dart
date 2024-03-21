import 'package:flutter/material.dart';
import 'package:idmall/pages/helpcenter.dart';
import 'package:idmall/pages/activation.dart';
import 'package:idmall/pages/survei.dart';

class Account extends StatelessWidget {
  const Account({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Akun',
          style: TextStyle(fontSize: 16), // Mengatur ukuran teks menjadi 16
        ),
        centerTitle: true, // Menengahkan judul
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Profile',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey, width: 2),
                      ),
                      child: CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage(
                            'images/profiles.png'), // Ganti dengan lokasi foto profil Anda
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),
                          Text('John Doe'),
                          SizedBox(height: 10),
                          Text('johndoe@example.com'),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ActivationPage()),
                              );
                            },
                            child: Text('Hubungkan Account'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            ListTile(
              leading: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey, width: 1),
                ),
                child: Icon(Icons.account_circle),
              ),
              title: Text('Account'),
              trailing: Icon(Icons.arrow_forward_ios), // Icon panah ke kanan
              onTap: () {},
            ),
            SizedBox(height: 15),
            ListTile(
              leading: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey, width: 1),
                ),
                child: Icon(Icons.location_on),
              ),
              title: Text('Alamat'),
              trailing: Icon(Icons.arrow_forward_ios), // Icon panah ke kanan
              onTap: () {
                // Tambahkan logika untuk tombol Alamat
              },
            ),
            SizedBox(height: 15),
            ListTile(
              leading: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey, width: 1),
                ),
                child: Icon(Icons.phone),
              ),
              title: Text('Pelanggan'),
              trailing: Icon(Icons.arrow_forward_ios), // Icon panah ke kanan
              onTap: () {
                // Navigasi ke halaman survei
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SurveyForm()),
                );
              },
            ),
            SizedBox(height: 15),
            ListTile(
              leading: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey, width: 1),
                ),
                child: Icon(Icons.help),
              ),
              title: Text('Help Center'),
              trailing: Icon(Icons.arrow_forward_ios), // Icon panah ke kanan
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HelpCenterPage()),
                );
              },
            ),
            SizedBox(height: 15),
            ListTile(
              leading: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey, width: 1),
                ),
                child: Icon(Icons.settings),
              ),
              title: Text('Settings'),
              trailing: Icon(Icons.arrow_forward_ios), // Icon panah ke kanan
              onTap: () {
                // Tambahkan logika untuk tombol Settings
              },
            ),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: () {
                  // Tambahkan logika untuk tombol Logout
                },
                child: Text(
                  'Logout',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.red,
                      fontWeight: FontWeight.bold), // Teks menjadi tebal
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
