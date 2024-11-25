// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:idmall/controller/account.controller.dart';

class FormChangeEmail extends StatefulWidget {
  const FormChangeEmail({super.key});

  @override
  _FormChangeEmailState createState() => _FormChangeEmailState();
}

class _FormChangeEmailState extends State<FormChangeEmail> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AccountController accountController = Get.put(AccountController());

  @override
  void initState() {
    super.initState();
  }

  void dispose() {
    accountController.emailController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ubah Email',
          style: TextStyle(fontSize: 16.0),
        ),
        centerTitle: true,
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
                    'Ubah Email',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              _buildTextField(accountController.emailController, 'Email'),
              const SizedBox(height: 16.0),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  accountController.updateEmail();
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
            return 'Mohon diisi';
          }
          // You can add additional email validation here
          return null;
        },
      ),
    );
  }
}
