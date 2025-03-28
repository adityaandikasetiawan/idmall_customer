// ignore_for_file: library_private_types_in_public_api, empty_catches, use_build_context_synchronously

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:idmall/consts.dart';
import 'package:idmall/widget/notificationpage.dart';
import 'package:idmall/widget/chatbotpage.dart';
import 'package:idmall/widget/shoppingchartpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EnterpriseSolutionPage extends StatefulWidget {
  const EnterpriseSolutionPage({super.key});

  @override
  _EnterpriseSolutionPageState createState() => _EnterpriseSolutionPageState();
}

class _EnterpriseSolutionPageState extends State<EnterpriseSolutionPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _needsController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _budgetController = TextEditingController();
  Dio dio = Dio();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String? token;
  String? fullName;
  String? lastName;
  String? email;

  String? _selectedBusinessIndustry;
  String? _selectedBusinessScale;

  final List<String> _businessScales = [
    'Micro',
    'Kecil',
    'Menegah',
    'Besar',
  ];

  @override
  void initState() {
    super.initState();
    getNameUser();
  }

  Future<Null> getNameUser() async {
    WidgetsFlutterBinding.ensureInitialized();
    final SharedPreferences prefs = await _prefs;

    setState(() {
      fullName = prefs.getString('fullName');
      email = prefs.getString('email');
      token = prefs.getString('token');
      _nameController.text = prefs.getString('fullName') ?? '';
      _emailController.text = prefs.getString('email') ?? '';
    });

    try {
      (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () =>
          HttpClient()
            ..badCertificateCallback =
                (X509Certificate cert, String host, int port) => true;
      var response = await dio.get('$linkLaravelAPI/customer/industry',
          options: Options(headers: {
            HttpHeaders.authorizationHeader: "Bearer $token",
          }));

      var data = response.data;
      if (data != '') {
        data = data['data'];
      }
    } catch (e) {}
  }

  Future<void> _submitForm(context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    String fullName = _nameController.text;
    String companyName = _companyNameController.text;
    String phone = _phoneController.text;
    String email = _emailController.text;
    String note = _noteController.text;
    String budget = _budgetController.text;
    String scale = _selectedBusinessScale!;
    String needs = _needsController.text;
    // File? file = _imageFile; // Access the selected file if needed;
    // File? file = _imageFile;
    fullName.split(' ');
    // String lastName = explode[explode.length - 1];
    // // String firstName = '';
    // // for (var i = 0; i < explode.length - 1; i++) {
    // //   firstName += explode[i] + ' ';
    // // }
    // // firstName = firstName.substring(0,firstName.length - 1);
    Map<String, dynamic> dataNya = {};
    dataNya = {
      'name': fullName.toString(),
      'company_name': companyName.toString(),
      'email': email.toString(),
      'note': note.toString(),
      'phone': phone.toString(),
      'budget': budget.toString(),
      'scale': scale.toString(),
      'needs': needs.toString(),
      'industry': _selectedBusinessIndustry.toString()
    };

    try {
      // Replace URL with your endpoint
      (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () =>
          HttpClient()
            ..badCertificateCallback =
                (X509Certificate cert, String host, int port) => true;
      var response =
          await dio.post('$linkLaravelAPI/customer/enterprise-solution',
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
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationPage(),
                ),
              );
            },
            icon: const Icon(Icons.notifications),
          ),
          const SizedBox(width: 10),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChatbotPage(),
                ),
              );
            },
            icon:
                Image.asset('images/widget/Chatbot.png', width: 15, height: 15),
          ),
          const SizedBox(width: 10),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ShoppingCartPage(),
                ),
              );
            },
            icon: const Icon(Icons.shopping_cart),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Enterprise\nSolution',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 1.0),
                    Expanded(
                      child: Image.asset(
                        'images/enterprisesolution.png',
                        width: 235,
                        height: 235,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              _buildTextField('Name', _nameController),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email is required';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: 'Mobile Number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Mobile Number is required';
                    }
                    return null;
                  },
                ),
              ),
              _buildTextField('Company Name', _companyNameController),
              DropdownSearch<String>(
                asyncItems: (String filter) async {
                  try {
                    (dio.httpClientAdapter as IOHttpClientAdapter)
                        .createHttpClient = () => HttpClient()
                      ..badCertificateCallback =
                          (X509Certificate cert, String host, int port) => true;
                    var response = await dio.get(
                      "$linkLaravelAPI/customer/industry",
                      queryParameters: {"chars": filter},
                    );
                    // print(jsonDecode(response.data)['status']);
                    if (response.data['status'] == 'success') {
                      var hasil = response.data['data'];
                      List<String> list = [];
                      for (var ele in hasil) {
                        list.add(ele['name']);
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
                    labelText: 'Business Industry',
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
                    _selectedBusinessIndustry = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a postal code';
                  }
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: DropdownButtonFormField<String>(
                  value: _selectedBusinessScale,
                  items: _businessScales.map((item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(item),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    labelText: 'Business Scale',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedBusinessScale = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Business Scale is required';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _budgetController,
                  decoration: InputDecoration(
                    labelText: 'Your IT Budget Monthly (IDR)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Your IT Budget Monthly (IDR) is required';
                    }
                    return null;
                  },
                ),
              ),
              _buildTextField('Note', _noteController),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _submitForm(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ), // Panggil _submitForm saat tombol ditekan
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

  Widget _buildTextField(String labelText, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '$labelText is required';
          }
          return null;
        },
      ),
    );
  }

  // void _submitForm() {
  //   if (_formKey.currentState!.validate()) {
  //     // Jika validasi berhasil, tangani pengiriman formulir di sini
  //     print('Form submitted successfully!');
  //     print('Name: ${_nameController.text}');
  //     print('Email: ${_emailController.text}');
  //     // ...akses bidang formulir lainnya dengan cara yang serupa
  //   }
  // }
}

void main() {
  runApp(const MaterialApp(
    home: EnterpriseSolutionPage(),
  ));
}
