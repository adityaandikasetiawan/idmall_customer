import 'package:flutter/material.dart';
import 'package:idmall/pages/helpcenter.dart';
import 'package:idmall/pages/activation.dart';
import 'package:idmall/pages/login.dart';
import 'package:idmall/pages/survei.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Account extends StatefulWidget {
  const Account({Key? key}) : super(key: key);

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  String? fullName;
  String? token;
  String? email;

  Future<void> getUser() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();

    setState(() {
      fullName = _pref.getString('fullName');
      token = _pref.getString('token');
      email = _pref.getString('email');
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
  }
  
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
      body: SingleChildScrollView(
        child: Padding(
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
                      Center(
                        child: Container(
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
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(fullName ?? ''),
                            SizedBox(height: 10),
                            Text(email ?? ''),
                            // SizedBox(height: 20),
                            // ElevatedButton(
                            //   onPressed: () {
                            //     Navigator.push(
                            //       context,
                            //       MaterialPageRoute(
                            //           builder: (context) => ActivationPage()),
                            //     );
                            //   },
                            //   child: Text('Hubungkan Account'),
                            // ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              // ListTile(
              //   leading: Container(
              //     width: 50,
              //     height: 50,
              //     decoration: BoxDecoration(
              //       shape: BoxShape.circle,
              //       border: Border.all(color: Colors.grey, width: 1),
              //     ),
              //     child: Icon(Icons.account_circle),
              //   ),
              //   title: Text('Account'),
              //   trailing: Icon(Icons.arrow_forward_ios), // Icon panah ke kanan
              //   onTap: () {},
              // ),
              // SizedBox(height: 15),
              // ListTile(
              //   leading: Container(
              //     width: 50,
              //     height: 50,
              //     decoration: BoxDecoration(
              //       shape: BoxShape.circle,
              //       border: Border.all(color: Colors.grey, width: 1),
              //     ),
              //     child: Icon(Icons.location_on),
              //   ),
              //   title: Text('Alamat'),
              //   trailing: Icon(Icons.arrow_forward_ios), // Icon panah ke kanan
              //   onTap: () {
              //     // Tambahkan logika untuk tombol Alamat
              //   },
              // ),
              // SizedBox(height: 15),
              // ListTile(
              //   leading: Container(
              //     width: 50,
              //     height: 50,
              //     decoration: BoxDecoration(
              //       shape: BoxShape.circle,
              //       border: Border.all(color: Colors.grey, width: 1),
              //     ),
              //     child: Icon(Icons.phone),
              //   ),
              //   title: Text('Pelanggan'),
              //   trailing: Icon(Icons.arrow_forward_ios), // Icon panah ke kanan
              //   onTap: () {
              //     // Navigasi ke halaman survei
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(builder: (context) => SurveyForm()),
              //     );
              //   },
              // ),
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
                child: ElevatedButton(
                  onPressed: () {
                    _logout(context);
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
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
void _logout(BuildContext context) async {
    // Menghapus data dari SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token'); // Misalnya, ini adalah kunci yang menandakan bahwa pengguna sudah login
    await prefs.remove('firstName'); // Misalnya, ini adalah kunci yang menandakan bahwa pengguna sudah login
    await prefs.remove('lastName'); // Misalnya, ini adalah kunci yang menandakan bahwa pengguna sudah login
    await prefs.remove('user_id'); // Misalnya, ini adalah kunci yang menandakan bahwa pengguna sudah login
    await prefs.remove('fullName'); // Misalnya, ini adalah kunci yang menandakan bahwa pengguna sudah login

    // Navigasi kembali ke halaman login atau halaman lain yang sesuai
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (builder) => Login()));
  }