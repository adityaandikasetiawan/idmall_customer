// ignore_for_file: library_private_types_in_public_api

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:idmall/config/config.dart' as config;

class FormChangePassword extends StatefulWidget {
  const FormChangePassword({super.key});

  @override
  _FormChangePasswordState createState() => _FormChangePasswordState();
}

class _FormChangePasswordState extends State<FormChangePassword> {
  String? token;

  Dio dio = Dio();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  Future<Null> getUser() async {
    WidgetsFlutterBinding.ensureInitialized();
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      token = prefs.getString('token');
    });
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  Future<void> _submitForm(context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;

    // print("$password, $confirmPassword}");
    if (password != confirmPassword) {
      return;
    }

    Map<String, dynamic> dataNya = {};

    dataNya = {
      'new_password': password.toString(),
    };

    try {
      // Replace URL with your endpoint
      (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () =>
          HttpClient()
            ..badCertificateCallback =
                (X509Certificate cert, String host, int port) => true;
      var response =
          await dio.patch('${config.backendBaseUrl}/user/change-password',
              data: dataNya,
              options: Options(headers: {
                HttpHeaders.authorizationHeader: "Bearer $token",
              }));

      // Handle response
      Map<String, dynamic> result = response.data;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(result['status']),
            content: Text(result['message']),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: const Text('Close'),
              ),
            ],
          );
        },
      );
      // Navigator.of(context).push(MaterialPageRoute(builder: (builder) => OrderPage()));
    } catch (e) {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    // _selectedServiceType = widget.tipe;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ubah Password',
          style: TextStyle(fontSize: 16.0), // Mengatur ukuran teks judul
        ),
        centerTitle: true, // Mengatur judul menjadi di tengah
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ubah Password',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              _buildTextField(_passwordController, 'Password'),
              const SizedBox(height: 16.0),
              _buildTextField(
                  _confirmPasswordController, 'Konfirmasi Password'),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  // Handle form submission
                  _submitForm(context);
                  // Navigator.of(context).push(MaterialPageRoute(builder: (builder) => OrderPage()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  minimumSize: const Size(double.infinity,
                      0), // Set minimum size untuk mengisi lebar layar
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0), // Atur padding vertical
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(color: Colors.grey),
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          border: InputBorder.none,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Wajib diisi';
          }
          // You can add additional email validation here
          return null;
        },
      ),
    );
  }
}
