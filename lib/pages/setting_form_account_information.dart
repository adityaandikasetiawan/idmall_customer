// ignore_for_file: library_private_types_in_public_api

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FormAccountInformation extends StatefulWidget {
  const FormAccountInformation({super.key});

  @override
  _FormAccountInformationState createState() => _FormAccountInformationState();
}

class _FormAccountInformationState extends State<FormAccountInformation> {
  String? token;
  Dio dio = Dio();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<Null> getNameUser() async {
    WidgetsFlutterBinding.ensureInitialized();
    final SharedPreferences prefs = await _prefs;

    setState(() {
      token = prefs.getString('token');
    });
  }

  @override
  void initState() {
    super.initState();
  }

  // Future<void> _submitForm(context) async {
  //   if (!_formKey.currentState!.validate()) {
  //     return;
  //   }
  //   String fullName = _customerNameController.text;
  //   String address = _installationAddressController.text;
  //   String phone = _phoneNumberController.text;
  //   String idCard = _idNumberController.text;
  //   String email = _emailController.text;
  //   String formLongitude = widget.longitude.toString();
  //   String formLatitude = widget.latitude.toString();
  //   // File? file = _imageFile; // Access the selected file if needed;
  //   // File? file = _imageFile;
  //   var explode = fullName.split(' ');
  //   String lastName = explode[explode.length - 1];
  //   String firstName = '';
  //   for (var i = 0; i < explode.length - 1; i++) {
  //     firstName += explode[i] + ' ';
  //   }
  //   firstName = firstName.substring(0,firstName.length - 1);
  //   String selectedServiceType = _selectedServiceType ?? '';
  //   String postalCodeType = _selectedZipCode ?? '';
  //   explode = postalCodeType.split('=>');
  //   postalCodeType = explode[0].trim();
  //   Map<String,dynamic> dataNya = {};
  //   int priceNya = int.parse(widget.price.replaceAll(RegExp(r'[^0-9]'),''));
  //   dataNya = {
  //     'first_name': firstName.toString(),
  //     'last_name': lastName.toString(),
  //     'email': email.toString(),
  //     'address': address.toString(),
  //     'phone': phone.toString(),
  //     'ktp': idCard.toString(),
  //     'zip_code': postalCodeType.toString(),
  //     'services': selectedServiceType.toString(),
  //     'longitude' : formLongitude.toString(),
  //     'latitude' : formLatitude.toString(),
  //     'harga' : widget.price.replaceAll(RegExp(r'[^0-9]'),'').toString()
  //   };
  //   FormData formData = FormData.fromMap(dataNya);
  //
  //   try {
  //     // Replace URL with your endpoint
  //     (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () =>
  //     HttpClient()
  //       ..badCertificateCallback =
  //           (X509Certificate cert, String host, int port) => true;
  //     var response = await dio.post('${config.backendBaseUrl}/subscription/retail/entri-prospek',
  //         data: dataNya,
  //         options: Options(headers: {
  //           HttpHeaders.authorizationHeader: "Bearer $token",
  //         }));
  //
  //     // Handle response
  //     Map<String,dynamic> result = response.data;
  //     print(result['status']);
  //     showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           title: Text(result['status']),
  //           content: Text(result['message']),
  //           actions: <Widget>[
  //             TextButton(
  //               onPressed: () {
  //                 Navigator.of(context).popUntil((route) => route.isFirst);
  //               },
  //               child: Text('Close'),
  //             ),
  //           ],
  //         );
  //       },
  //     );
  //     // Navigator.of(context).push(MaterialPageRoute(builder: (builder) => OrderPage()));
  //   } catch (e) {
  //     // Handle error
  //     print(e.toString());
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // _selectedServiceType = widget.tipe;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Informasi Akun',
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
                    'Akun',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              _buildTextField(_firstNameController, 'Nama Depan'),
              const SizedBox(height: 16.0),
              _buildTextField(_lastNameController, 'Nama Belakang'),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  // Handle form submission
                  // _submitForm(context);
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
