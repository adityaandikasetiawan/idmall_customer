import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ActivationPage extends StatefulWidget {
  @override
  _ActivationPageState createState() => _ActivationPageState();
}

class _ActivationPageState extends State<ActivationPage> {
  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _installationAddressController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _idNumberController = TextEditingController();
  final TextEditingController _mobilePhoneController = TextEditingController();
  final TextEditingController _referralCodeController = TextEditingController();
  String? _selectedServiceType;
  bool _agreeToTerms = false;
  late File _image;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Aktivation'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Form Aktivasi Berlangganan',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            _buildTextField(_customerNameController, 'Nama Pelanggan'),
            SizedBox(height: 16.0),
            _buildTextField(_installationAddressController, 'Alamat Pemasangan'),
            SizedBox(height: 16.0),
            _buildTextField(_phoneNumberController, 'Telepon / Telepon Seluler'),
            SizedBox(height: 16.0),
            _buildKtpUploadField(),
            SizedBox(height: 16.0),
            _buildTextField(_idNumberController, 'No Identitas (KTP)'),
            SizedBox(height: 16.0),
            _buildTextField(_mobilePhoneController, 'Telepon Selular'),
            SizedBox(height: 16.0),
            _buildDropdownButtonFormField(),
            SizedBox(height: 16.0),
            _buildTextField(_referralCodeController, 'Referal Code'),
            SizedBox(height: 16.0),
            Row(
              children: [
                Checkbox(
                  value: _agreeToTerms,
                  onChanged: (bool? value) {
                    setState(() {
                      _agreeToTerms = value ?? false;
                    });
                  },
                ),
                Text(
                  'I agree to terms & conditions',
                  style: TextStyle(fontSize: 14.0),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Handle form submission
              },
              child: Text('Submit'),
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
          contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
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
        decoration: InputDecoration(
          labelText: 'Jenis Layanan',
          contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
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
          final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
          if (image != null) {
            setState(() {
              _image = File(image.path);
            });
          }
        },
        icon: Image.asset(
          'images/upload.png', // Replace 'images/upload.png' with your image path
          width: 24, // Adjust width as needed
          height: 24, // Adjust height as needed
        ),
        label: Text('Upload KTP'),
      ),
    );
  }

  void _handleKtpUpload() {
    // Add logic to handle KTP upload
    print('KTP uploaded!');
    // You can replace print statement with actual upload functionality
  }
}

void main() {
  runApp(MaterialApp(
    home: ActivationPage(),
  ));
}
