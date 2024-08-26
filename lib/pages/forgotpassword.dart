// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:idmall/pages/signup.dart';
import 'package:idmall/config/config.dart' as config;
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController emailcontroller = TextEditingController();

  String email = "";

  final _formkey = GlobalKey<FormState>();

  resetPassword() async {
    final dio = Dio();

    try {
      final response = await dio.post(
        '${config.backendBaseUrl}/user/password/reset/send',
        data: {
          "target_email": email,
        },
        options: Options(
          headers: {
            "Cache-Control": "no-cache"
          }
        )
      );

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Success"),
            content: Text(response.data['message']),
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
    } on DioException catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Warning"),
            content: Text(e.response?.data),
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(top: 155.0, left: 20),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Lupa Password",
                          style: TextStyle(
                            color:
                                Colors.black, // Ubah warna teks menjadi hitam
                            fontWeight:
                                FontWeight.bold, // Tambahkan gaya teks bold
                            fontSize:
                                20.0, // Sesuaikan ukuran font jika diperlukan
                            fontFamily:
                                'Poppins', // Sesuaikan jenis font jika diperlukan
                          ),
                        ),
                        SizedBox(
                            height:
                                20), // Padding tambahan di bagian bawah judul
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(0.5),
                  margin: const EdgeInsets.only(
                      right: 20.0), // Geser ke kanan sebesar 10px
                  child: Image.asset(
                    'images/signup.png', // Ganti dengan path gambar yang sesuai
                    height: 250,
                    width: 250,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          Expanded(
              child: Form(
            key: _formkey,
            child: Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15),
              child: ListView(
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 10.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: const Color.fromARGB(255, 93, 92, 92),
                          width: 2.0),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextFormField(
                      controller: emailcontroller,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter Email';
                        }
                        return null;
                      },
                      style: const TextStyle(
                          color: Color.fromARGB(255, 93, 92, 92)),
                      decoration: const InputDecoration(
                          hintText: "Masukkan Email",
                          hintStyle: TextStyle(
                            fontSize: 18.0,
                            color: Color.fromARGB(255, 93, 92, 92),
                          ),
                          prefixIcon: Icon(
                            Icons.person,
                            color: Color.fromARGB(255, 93, 92, 92),
                            size: 30.0,
                          ),
                          border: InputBorder.none),
                    ),
                  ),
                  const SizedBox(height: 8.0), // Jarak satu kali
                  const Text(
                    "Kami Akan Mengirimkan Anda Sebuah Pesan Untuk Mengubah Password Anda",
                    style: TextStyle(
                        fontSize: 10.0, color: Color.fromARGB(255, 93, 92, 92)),
                  ),
                  const SizedBox(
                    height: 40.0,
                  ),
                  GestureDetector(
                    onTap: () {
                      if (_formkey.currentState!.validate()) {
                        setState(() {
                          email = emailcontroller.text;
                        });
                        resetPassword();
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: 140,
                      height: 55,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 228, 99, 7),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        "Kirimkan Email",
                        style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 50.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Belum Memiliki Akun?",
                        style: TextStyle(
                            fontSize: 18.0,
                            color: Color.fromARGB(255, 93, 92, 92)),
                      ),
                      const SizedBox(
                        width: 5.0,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignUp()));
                        },
                        child: const Text(
                          "Daftar",
                          style: TextStyle(
                              color: Color.fromARGB(255, 228, 99, 7),
                              fontSize: 20.0,
                              fontWeight: FontWeight.w500),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }
}
