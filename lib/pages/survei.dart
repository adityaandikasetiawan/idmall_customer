import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SurveyForm extends StatefulWidget {
  @override
  _SurveyFormState createState() => _SurveyFormState();
}

class _SurveyFormState extends State<SurveyForm> {
  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _installationAddressController =
      TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _idNumberController = TextEditingController();
  final TextEditingController _referralCodeController = TextEditingController();
  String? _selectedServiceType;
  late File _image;
  final ImagePicker _picker = ImagePicker();
  bool _agreeToTerms = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Survey',
          style: TextStyle(fontSize: 16.0), // Mengatur ukuran teks judul
        ),
        centerTitle: true, // Mengatur judul menjadi di tengah
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
                  'Form Survey Berlangganan',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            _buildTextField(_customerNameController, 'Nama Customer'),
            SizedBox(height: 16.0),
            _buildTextField(
                _installationAddressController, 'Alamat Pemasangan'),
            SizedBox(height: 16.0),
            _buildTextField(_phoneNumberController, 'Telepon/ Telepon Seluler'),

            SizedBox(height: 16.0),
            _buildTextField(_idNumberController, 'Nomor Identitas'),
            SizedBox(height: 16.0),
            _buildDropdownButtonFormField(),

            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Handle form submission
              },
              child: Text(
                'Submit',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                minimumSize: Size(double.infinity,
                    0), // Set minimum size untuk mengisi lebar layar
                padding: EdgeInsets.symmetric(
                    vertical: 16.0), // Atur padding vertical
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
              EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
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
          labelText: 'Service Type',
          contentPadding:
              EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          border: InputBorder.none,
        ),
      ),
    );
  }

 
  
}

void main() {
  runApp(MaterialApp(
    home: SurveyForm(),
  ));
}
