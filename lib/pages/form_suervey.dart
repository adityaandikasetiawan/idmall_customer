// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/material.dart';
import 'package:idmall/consts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:idmall/models/zip_code.dart';
import 'package:idmall/config/config.dart' as config;

class FormSurvey extends StatefulWidget {
  final double latitude;
  final double longitude;
  final String tipe;
  final String price;
  final String productCode;
  final String address;
  final String zipcode;

  const FormSurvey({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.tipe,
    required this.price,
    required this.productCode,
    required this.address,
    required this.zipcode,
  });
  @override
  _FormSurveyState createState() => _FormSurveyState();
}

class _FormSurveyState extends State<FormSurvey> {
  String? fullName;
  String? email;
  String? token;
  String? _selectedZipCode;
  Dio dio = Dio();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _services = TextEditingController();
  final TextEditingController _installationAddressController =
      TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _idNumberController = TextEditingController();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<Null> getNameUser() async {
    WidgetsFlutterBinding.ensureInitialized();
    final SharedPreferences prefs = await _prefs;
    setState(() {
      fullName = prefs.getString('fullName');
      email = prefs.getString('email');
      token = prefs.getString('token');
      _customerNameController.text = prefs.getString('fullName') ?? '';
      _emailController.text = prefs.getString('email') ?? '';
    });
  }

  @override
  void initState() {
    super.initState();
    getNameUser();
  }

  Future<void> _submitForm(context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    String fullName = _customerNameController.text;
    String address = _installationAddressController.text;
    String phone = _phoneNumberController.text;
    String idCard = _idNumberController.text;
    String email = _emailController.text;
    String formLongitude = widget.longitude.toString();
    String formLatitude = widget.latitude.toString();
    var explode = fullName.split(' ');
    String lastName = explode[explode.length - 1];
    String firstName = '';
    for (var i = 0; i < explode.length - 1; i++) {
      firstName += '${explode[i]} ';
    }
    firstName = firstName.substring(0, firstName.length - 1);
    String postalCodeType = _selectedZipCode ?? '';
    explode = postalCodeType.split('=>');
    postalCodeType = explode[0].trim();
    Map<String, dynamic> dataNya = {};
    // int.parse(widget.price.replaceAll(RegExp(r'[^0-9]'), ''));
    dataNya = {
      'first_name': firstName.toString(),
      'last_name': lastName.toString(),
      'fullname': fullName.toString(),
      'email': email.toString(),
      'address': address.toString(),
      'phone': phone.toString(),
      'ktp': idCard.toString(),
      'zip_code': postalCodeType.toString(),
      'services': _services.text,
      'longitude': formLongitude.toString(),
      'latitude': formLatitude.toString(),
      // 'harga': widget.price.replaceAll(RegExp(r'[^0-9]'), '').toString()
      'harga': widget.price,
      'product_code': widget.productCode
    };

    try {
      (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () =>
          HttpClient()
            ..badCertificateCallback =
                (X509Certificate cert, String host, int port) => true;
      var response = await dio.post(
          '${config.backendBaseUrl}/subscription/retail/entri-prospek',
          data: dataNya,
          options: Options(headers: {
            HttpHeaders.authorizationHeader: "Bearer $token",
            HttpHeaders.cacheControlHeader: "no-cache"
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
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text("Terjadi kesalahan"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Close'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _services.text = widget.tipe;
    _installationAddressController.text = widget.address;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Survey',
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
                    'Form Pendaftaran Berlangganan',
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
              _buildTextField(_emailController, 'Email Customer'),
              const SizedBox(height: 16.0),
              _buildTextField(
                  _installationAddressController, 'Alamat Lengkap Pemasangan'),
              const SizedBox(height: 16.0),
              DropdownSearch<String>(
                asyncItems: (String filter) async {
                  try {
                    (dio.httpClientAdapter as IOHttpClientAdapter)
                        .createHttpClient = () => HttpClient()
                      ..badCertificateCallback =
                          (X509Certificate cert, String host, int port) => true;
                    var response = await dio.get(
                      "$linkLaravelAPI/entri-data/zipcode",
                      queryParameters: {"chars": filter},
                    );
                    // print(jsonDecode(response.data)['status']);
                    if (jsonDecode(response.data)['status'] == 'success') {
                      var hasil = jsonDecode(response.data)['data'];
                      List<String> list = [];
                      for (var ele in hasil) {
                        var zipCodeModel = ZipCode.fromJson(ele);
                        var zipCodeNya = zipCodeModel.zipCode.toString();
                        var kelurahan = zipCodeModel.district.toString();
                        var kota = zipCodeModel.city.toString();
                        var provinsi = zipCodeModel.province.toString();
                        list.add("$zipCodeNya => $kelurahan, $kota, $provinsi");
                      }
                      // print(model[0]);
                      return list;
                    } else {
                      return [];
                    }
                  } on DioException catch (e) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Error"),
                          content: Text(e.message ?? ''),
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
                    return [];
                  }
                },
                dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    labelText: 'Kode Pos',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                ),
                popupProps: const PopupProps.menu(
                  showSelectedItems: true,
                  isFilterOnline: true,
                  showSearchBox: true,
                  // disabledItemFn: (String s) => s.startsWith('I'),
                ),
                items: const [],
                onChanged: (String? value) {
                  setState(() {
                    _selectedZipCode = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a postal code';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              _buildTextField(
                  _phoneNumberController, 'Telepon/ Telepon Seluler'),
              const SizedBox(height: 16.0),
              _buildTextField(
                  _idNumberController, 'Nomor Identitas (NIK/SIM/Passport)'),
              const SizedBox(height: 16.0),
              // _buildDropdownButtonFormField(),
              _buildTextField(_services, 'Layanan'),
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
