// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously, duplicate_ignore

import 'package:flutter/material.dart';
import 'package:idmall/config/config.dart';
import 'package:idmall/pages/feedback.dart';
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
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                color: Colors.amber[50],
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
                            border: Border.all(
                              color: Colors.grey,
                              width: 2,
                            ),
                          ),
                          child: const CircleAvatar(
                            radius: 30,
                            backgroundImage: AssetImage(
                              'images/profiles.png',
                            ), // Ganti dengan lokasi foto profil Anda
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
                            Column(
                              children: [
                                if (is_email_verified == "1")
                                  const Text("Terverifikasi")
                                else ...[
                                  const Text("Belum verifikasi"),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      textStyle: const TextStyle(fontSize: 16),
                                    ),
                                    onPressed: verifyEmailAddress,
                                    child: const Text('Verifikasi'),
                                  ),
                                ]
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15),
              ListTile(
                leading: const Icon(Icons.help),
                title: const Text('Help Center'),
                trailing:
                    const Icon(Icons.arrow_forward_ios), // Icon panah ke kanan
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HelpCenterPage(),
                    ),
                  );
                },
              ),
              Divider(),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Settings'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingChangePasswordPage(),
                    ),
                  );
                },
              ),
              Divider(),
              ListTile(
                leading: const Icon(Icons.move_to_inbox_rounded),
                title: const Text('Saran & Masukkan'),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                ), // Icon panah ke kanan
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FeedbackPage(),
                    ),
                  );
                },
              ),
              Divider(),
              const SizedBox(height: 50),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _logout(context);
                    // Tambahkan logika untuk tombol Logout
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange[300],
                  ),
                  child: const Text(
                    'Logout',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ), // Teks menjadi tebal
                  ),
                ),
              ),
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
