import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/material.dart';
import 'package:idmall/consts.dart';
import 'package:idmall/widget/pesanan.dart';
import 'package:idmall/widget/shoppingchartpage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:idmall/models/zip_code.dart';

class FormSurvey extends StatefulWidget {
  final double latitude;
  final double longitude;
  final String tipe;

  FormSurvey({super.key, required this.latitude, required this.longitude, required this.tipe});
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
  final TextEditingController _installationAddressController =
      TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _idNumberController = TextEditingController();
  final TextEditingController _referralCodeController = TextEditingController();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<Null> getNameUser() async {
    WidgetsFlutterBinding.ensureInitialized();
    final SharedPreferences? prefs = await _prefs;

    setState(() {
      fullName = prefs?.getString('fullName');
      email = prefs?.getString('email');
      token = prefs?.getString('token');
      _customerNameController.text = prefs?.getString('fullName') ?? '';
    });
  }
  
  String? _selectedServiceType;
  late File _image;
  final ImagePicker _picker = ImagePicker();
  bool _agreeToTerms = false;

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
    String formLongitude = widget.longitude.toString();
    String formLatitude = widget.latitude.toString();
    // File? file = _imageFile; // Access the selected file if needed;
    // File? file = _imageFile;
    String selectedServiceType = _selectedServiceType ?? '';
    String postalCodeType = _selectedZipCode ?? '';
    Map<String,dynamic> dataNya = {};
    dataNya = {
      'name': fullName,
      'email': email,
      'address': address,
      'phone': phone,
      'ktp': idCard,
      'zipcode': postalCodeType,
      'service': selectedServiceType,
      'longitude' : formLongitude,
      'latitude' : formLatitude,
    };
    FormData formData = FormData.fromMap(dataNya);

    try {
      // Replace URL with your endpoint
      (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () =>
                      HttpClient()
                        ..badCertificateCallback =
                            (X509Certificate cert, String host, int port) => true;
      var response = await dio.post('$linkLaravelAPI/entri-data/submit',
          data: formData,
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: 'multipart/form-data',
            HttpHeaders.authorizationHeader: token,
          }));

      // Handle response
      print(jsonDecode(response.data));
      return Navigator.of(context).pop();
    } catch (e) {
      // Handle error
      print(e.toString());
    }
  }


  @override
  Widget build(BuildContext context) {
    _selectedServiceType = widget.tipe;
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

            _buildTextField(_installationAddressController, 'Alamat Lengkap Pemasangan'),
            SizedBox(height: 16.0),
            
            _dropdownButtonFormField(_selectedZipCode, 'Kode Pos'),
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
                Navigator.of(context).push(MaterialPageRoute(builder: (builder) => OrderPage()));
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
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
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
            print(newValue);
            _selectedServiceType = newValue;
          });
        },
        items: <String>[
          'idplay Retail Up To 10 Mbps',
          'idplay Retail Up To 20 Mbps',
          'idplay Retail Up To 30 Mbps',
          'idplay Retail Up To 50 Mbps',
          'idplay Retail Up To 100 Mbps',
          'idplay Retail Up To 200 Mbps',
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
  Widget _dropdownButtonFormField(variable, title) {
    return DropdownSearch<String>(
      asyncItems: (String filter) async {
        try {
          (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () =>
        HttpClient()
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
          }else {
            return [];
          }
        } on DioException catch (e) {
          print(e);
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
      items: [],
      onChanged: (String? value) {
        setState(() {
          variable = value;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a postal code';
        }
        return null;
      },
    );
  }
}

