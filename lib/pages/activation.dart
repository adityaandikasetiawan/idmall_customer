// ignore_for_file: unused_import, library_private_types_in_public_api

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ActivationPage extends StatefulWidget {
  const ActivationPage({super.key});

  @override
  _ActivationPageState createState() => _ActivationPageState();
}

class _ActivationPageState extends State<ActivationPage> {
  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _installationAddressController =
      TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _idNumberController = TextEditingController();
  final TextEditingController _referralCodeController = TextEditingController();
  String? _selectedServiceType;
  final ImagePicker _picker = ImagePicker();
  bool _agreeToTerms = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activation'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Form Kontrak Berlangganan',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            _buildTextField(_customerNameController, 'Nama Customer'),
            const SizedBox(height: 16.0),
            _buildTextField(
                _installationAddressController, 'Alamat Pemasangan'),
            const SizedBox(height: 16.0),
            _buildTextField(_phoneNumberController, 'Telepon/ Telepon Seluler'),
            const SizedBox(height: 16.0),
            _buildKtpUploadField(),
            const SizedBox(height: 16.0),
            _buildTextField(_idNumberController, 'Nomor Identitas'),
            const SizedBox(height: 16.0),
            _buildDropdownButtonFormField(),
            const SizedBox(height: 16.0),
            _buildTextField(_referralCodeController, 'Handler'),
            const SizedBox(height: 16.0),
            Row(
              children: [
                Checkbox(
                  value: _agreeToTerms,
                  onChanged: (bool? value) {
                    setState(() {
                      _agreeToTerms = value ?? false;
                      if (_agreeToTerms) {
                        _showAgreementPopup(
                            context); // Show agreement popup when checkbox is checked
                      }
                    });
                  },
                ),
                const Text(
                  'I agree to terms & conditions',
                  style: TextStyle(fontSize: 14.0),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Handle form submission
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
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(color: Colors.grey),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildDropdownButtonFormField() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(color: Colors.grey),
      ),
      child: DropdownButtonFormField<String>(
        value: _selectedServiceType,
        onChanged: (String? newValue) {
          setState(() {
            _selectedServiceType = newValue;
          });
        },
        items: <String>[
          'IdPlay Home 10Mb',
          'IdPlay Home 20Mb',
          'IdPlay Home 30Mb',
          'IdPlay Home 50Mb',
          'IdPlay Home 100Mb',
        ].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        decoration: const InputDecoration(
          labelText: 'Service Type',
          contentPadding:
              EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildKtpUploadField() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(
          color: Colors.grey,
          style: BorderStyle.solid,
          width: 1.0,
        ),
      ),
      child: TextButton.icon(
        onPressed: () async {
          final XFile? image =
              await _picker.pickImage(source: ImageSource.gallery);
          if (image != null) {
            setState(() {});
          }
        },
        icon: const Icon(Icons.upload_file), // Change icon to your preference
        label: const Text('Upload ID'), // Change label to your preference
      ),
    );
  }

  void _showAgreementPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Terms & Conditions'),
          content: const SingleChildScrollView(
            child: Text(
              // Your agreement content here
              'By clicking "I agree", you agree to the terms and conditions...',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
            TextButton(
              onPressed: () {
                // Add your logic for handling agreement acceptance
                // For example, you can set a variable to indicate agreement acceptance
                // _agreeToTerms = true;
                // Then proceed with further actions.
                Navigator.of(context).pop();
              },
              child: const Text('I Agree'),
            ),
          ],
        );
      },
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: ActivationPage(),
  ));
}
