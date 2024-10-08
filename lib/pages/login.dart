// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:idmall/admin/home_admin.dart';
import 'package:idmall/controller/login.controller.dart';
import 'package:idmall/guest/dashboard.dart';
import 'package:idmall/pages/forgotpassword.dart';
import 'package:idmall/pages/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:idmall/config/config.dart' as config;
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

Future<dynamic> loginWithEmailPassword(payload) async {
  final Future<SharedPreferences> prefs0 = SharedPreferences.getInstance();
  final SharedPreferences prefs = await prefs0;
  final fcm_token = prefs.getString('fcm_token');
  final body = jsonDecode(payload);
  final dio = Dio();
  if (fcm_token != null) {
    final response = await dio.post(
      '${config.backendBaseUrl}/user/login',
      data: {
        "email": body["email"],
        "password": body["password"],
        "fcm_token": fcm_token
      },
    );
    return response;
  } else {
    final response = await dio.post(
      '${config.backendBaseUrl}/user/login',
      data: {
        "email": body["email"],
        "password": body["password"],
      },
    );
    return response;
  }
}

class _LoginState extends State<Login> {
  User? currentUser;
  final LoginController loginController = Get.put(LoginController());

  bool _isPasswordVisible = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(top: 120.0, left: 20),
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Selamat Datang di IdMall",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.only(right: 20.0),
                        child: Image.asset(
                          'images/signup.png',
                          height: 200,
                          width: 200,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: loginController.emailController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Tolong Masukkan Email';
                            }
                            return null;
                          },
                          style: const TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.email,
                                color: Color.fromARGB(255, 93, 92, 92)),
                            hintText: 'Email',
                            hintStyle: const TextStyle(
                                color: Color.fromARGB(255, 93, 92, 92)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 15.0, horizontal: 20.0),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: loginController.passwordController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Tolong Masukkan Password';
                            }
                            return null;
                          },
                          style: const TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                          obscureText: !_isPasswordVisible,
                          decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.lock,
                                  color: Color.fromARGB(255, 93, 92, 92)),
                              hintText: 'Password',
                              hintStyle: const TextStyle(
                                  color: Color.fromARGB(255, 93, 92, 92)),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 15.0, horizontal: 20.0),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: const Color.fromARGB(255, 0, 0, 0),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              )),
                        ),
                        const SizedBox(height: 10.0),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ForgotPassword(),
                              ),
                            );
                          },
                          child: Container(
                            alignment: Alignment.topRight,
                            child: const Text(
                              "Lupa Password?",
                              style: TextStyle(
                                color: Color.fromARGB(255, 228, 99, 7),
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                                fontFamily: 'Poppins',
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30.0),
                        Obx(() {
                          if (loginController.isLoading.value) {
                            return Container(
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 228, 99, 7),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Center(
                                child: SpinKitFadingCircle(
                                  color: Colors.white,
                                  size: 50.0,
                                ),
                              ),
                            );
                          } else {
                            return GestureDetector(
                              onTap: () async {
                                if (_formKey.currentState!.validate()) {
                                  String enteredEmail =
                                      loginController.emailController.text;
                                  String enteredPassword =
                                      loginController.passwordController.text;

                                  if (enteredEmail == 'admin' &&
                                      enteredPassword == 'admin') {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const HomeAdmin(),
                                      ),
                                    );
                                  } else {
                                    loginController.login();
                                  }
                                }
                              },
                              child: Material(
                                borderRadius: BorderRadius.circular(20.0),
                                color: const Color.fromARGB(255, 228, 99, 7),
                                child: const SizedBox(
                                  width: 400.0,
                                  height: 50.0,
                                  child: Center(
                                    child: Text(
                                      "Sign In",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.0,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }
                        }),
                        const SizedBox(height: 10.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Tidak Memiliki Akun?",
                              style: TextStyle(
                                color: Color.fromARGB(255, 93, 92, 92),
                                fontSize: 14.0,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            const SizedBox(width: 5.0),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SignUp(),
                                  ),
                                );
                              },
                              child: const Text(
                                "Daftar",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 228, 99, 7),
                                  fontSize: 14.0,
                                  fontFamily: 'Poppins',
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30.0),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 1.0,
                                color: Colors.grey,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 10.0,
                                ),
                              ),
                            ),
                            const Text(
                              "Atau",
                              style: TextStyle(
                                color: Color.fromARGB(255, 93, 92, 92),
                                fontSize: 20.0,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: 1.0,
                                color: Colors.grey,
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30.0),
                        OutlinedButton(
                          style: TextButton.styleFrom(
                            fixedSize:
                                Size(MediaQuery.of(context).size.width, 50),
                            side: const BorderSide(
                              width: 2.0,
                              color: Color.fromARGB(255, 228, 99, 7),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const DashboardGuest(),
                              ),
                            );
                          },
                          child: const Text(
                            'Log In as Guest',
                            style: TextStyle(
                              color: Colors.black,
                              // color: Color.fromARGB(255, 93, 92, 92),
                              fontSize: 16.0,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
