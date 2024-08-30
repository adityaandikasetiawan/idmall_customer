// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously, duplicate_ignore

import 'package:flutter/material.dart';
import 'package:idmall/config/config.dart';
import 'package:idmall/pages/helpcenter.dart';
import 'package:idmall/pages/login.dart';
import 'package:idmall/pages/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  String? fullName;
  String? token;
  String? email;
  String? is_email_verified = "0";

  Future<void> getUser() async {
    // ignore: no_leading_underscores_for_local_identifiers
    SharedPreferences _pref = await SharedPreferences.getInstance();

    setState(() {
      fullName = _pref.getString('fullName');
      token = _pref.getString('token');
      email = _pref.getString('email');
      is_email_verified = _pref.getString('is_email_verified');
    });
  }

  Future<void> verifyEmailAddress() async {
    Dio dio = Dio();
    var headers = {"Authorization": "Bearer $token"};
    Response response =
        await dio.post("$backendBaseUrl/send-verification-email",
            data: {
              "target_email": email,
            },
            options: Options(
              headers: headers,
            ));

    if (response.statusCode == 200) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("success"),
            content: const Text(
                "Berhasil mengirimkan email, silahkan cek kotak masuk email anda"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  void initState() {
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
              const Text(
                'Profile',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
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
                          child: const CircleAvatar(
                            radius: 30,
                            backgroundImage: AssetImage(
                                'images/profiles.png'), // Ganti dengan lokasi foto profil Anda
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(fullName ?? ''),
                            const SizedBox(height: 10),
                            Text(email ?? ''),
                            Column(children: [
                              if (is_email_verified == "1")
                                const Text("Terverifikasi")
                              else ...[
                                const Text("Belum verifikasi"),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      textStyle: const TextStyle(fontSize: 16)),
                                  onPressed: verifyEmailAddress,
                                  child: const Text('Verifikasi'),
                                ),
                              ]
                            ]),

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
              const SizedBox(height: 20),
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
              const SizedBox(height: 15),
              ListTile(
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey, width: 1),
                  ),
                  child: const Icon(Icons.help),
                ),
                title: const Text('Help Center'),
                trailing:
                    const Icon(Icons.arrow_forward_ios), // Icon panah ke kanan
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HelpCenterPage()),
                  );
                },
              ),
              const SizedBox(height: 15),
              ListTile(
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey, width: 1),
                  ),
                  child: const Icon(Icons.settings),
                ),
                title: const Text('Settings'),
                trailing:
                    const Icon(Icons.arrow_forward_ios), // Icon panah ke kanan
                onTap: () {
                  // Tambahkan logika untuk tombol Settings
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const SettingChangePasswordPage()),
                  );
                },
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () {
                    _logout(context);
                    // Tambahkan logika untuk tombol Logout
                  },
                  child: const Text(
                    'Logout',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.red,
                        fontWeight: FontWeight.bold), // Teks menjadi tebal
                  ),
                ),
                
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () {
                    _deleteAccount(context);
                    // Tambahkan logika untuk tombol Hapus Akun
                  },
                  child: const Text(
                    'Hapus Akun',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.red,
                      fontWeight: FontWeight.bold, // Teks menjadi tebal
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}

void _deleteAccount(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Hapus Akun"),
        content: const Text(
          "Apakah Anda yakin ingin menghapus akun? Tindakan ini tidak dapat dibatalkan.",
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Menutup dialog
            },
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () {
              // Tambahkan logika untuk menghapus akun di sini
              Navigator.of(context).pop(); // Menutup dialog setelah menghapus akun
              _logout(context);
            },
            child: const Text("Hapus"),
          ),
        ],
      );
    },
  );
}
void _logout(BuildContext context) async {
  // Menghapus data dari SharedPreferences
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove(
      'token'); // Misalnya, ini adalah kunci yang menandakan bahwa pengguna sudah login
  await prefs.remove(
      'firstName'); // Misalnya, ini adalah kunci yang menandakan bahwa pengguna sudah login
  await prefs.remove(
      'lastName'); // Misalnya, ini adalah kunci yang menandakan bahwa pengguna sudah login
  await prefs.remove(
      'user_id'); // Misalnya, ini adalah kunci yang menandakan bahwa pengguna sudah login
  await prefs.remove(
      'fullName'); // Misalnya, ini adalah kunci yang menandakan bahwa pengguna sudah login

  // Navigasi kembali ke halaman login atau halaman lain yang sesuai
  // ignore: use_build_context_synchronously
  Navigator.of(context)
      .pushReplacement(MaterialPageRoute(builder: (builder) => const Login()));
}
