import 'dart:convert';
import 'dart:io';
import 'package:dio/io.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:idmall/models/customer_detail.dart';
import 'package:idmall/consts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:idmall/config/config.dart' as config;

class UpgradeDowngradeDetail extends StatefulWidget {
  final String task;
  final String sid;
  const UpgradeDowngradeDetail({
    super.key,
    required this.task,
    required this.sid,
  });

  @override
  State<UpgradeDowngradeDetail> createState() => _UpgradeDowngradeDetailState();
}

class _UpgradeDowngradeDetailState extends State<UpgradeDowngradeDetail> {
  String? firstName;
  String? lastName;
  String? token;
  String? taskId;
  double? latitude;
  double? longitude;
  Dio dio = Dio();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  @override
  void initState() {
    super.initState();
    getNameUser();
    getCustomer();
  }

  Future<Null> getNameUser() async {
    WidgetsFlutterBinding.ensureInitialized();
    final SharedPreferences prefs = await _prefs;
    Position? position = await _determinePosition();

    setState(() {
      firstName = prefs.getString('firstName');
      lastName = prefs.getString('lastName');
      token = prefs.getString('token');
      taskId = prefs.getString('taskId');
      latitude = position.latitude;
      longitude = position.longitude;
    });
  }

  Future<Null> getCustomer() async {
    (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () =>
        HttpClient()
          ..badCertificateCallback =
              (X509Certificate cert, String host, int port) => true;
    var response = await dio.get("$linkLaravelAPI/entri-data/customer-detail",
        queryParameters: {"task": widget.task},
        options: Options(headers: {
          HttpHeaders.authorizationHeader: token,
        }));
    // print(response.data);
    // print(jsonDecode(response.data)['status']);
    if (jsonDecode(response.data)['status'] == 'success') {
      var hasil = jsonDecode(response.data)['data'];
      CustomerDetailAchieve jsonNya = CustomerDetailAchieve.fromJson(hasil);
      setState(() {
        _firstNameController.text = jsonNya.name;
        _lastNameController.text = jsonNya.name;
        _emailController.text = jsonNya.email;
        _addressController.text = jsonNya.address;
        _phoneController.text = jsonNya.handphone;
        _idCardController.text = jsonNya.ktp!;
        _latitudeController.text = jsonNya.latitude;
        _longitudeController.text = jsonNya.longitude;
      });
    }
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _idCardController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();

  Future<void> _submitForm(context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final response = await dio.post(
      "${config.backendBaseUrl}/request-du",
      options: Options(
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
          "Cache-Control": "no-cache"
        },
      ),
      data: {
        "task_id": taskId,
        "note": _noteController.text,
      },
    );

    Get.snackbar(response.data['status'], response.data['message']);
    Get.off(
      () => UpgradeDowngradeDetail(task: widget.task, sid: ""),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Request Upgrade'),
        // automaticallyImplyLeading : false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          // controller: controller,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Material(
                    elevation: 5,
                    borderRadius: BorderRadius.circular(10.0),
                    shadowColor: Colors.grey,
                    child: TextFormField(
                      controller: _firstNameController,
                      decoration: InputDecoration(
                        labelText: 'Nama Depan',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      readOnly: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your first name';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Material(
                    elevation: 5,
                    borderRadius: BorderRadius.circular(10.0),
                    shadowColor: Colors.grey,
                    child: TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        // You can add additional email validation here
                        return null;
                      },
                      readOnly: true,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Material(
                    elevation: 5,
                    borderRadius: BorderRadius.circular(10.0),
                    shadowColor: Colors.grey,
                    child: TextFormField(
                      controller: _addressController,
                      decoration: InputDecoration(
                        labelText: 'Alamat',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your address';
                        }
                        // You can add additional email validation here
                        return null;
                      },
                      readOnly: true,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Material(
                    elevation: 5,
                    borderRadius: BorderRadius.circular(10.0),
                    shadowColor: Colors.grey,
                    child: TextFormField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                        labelText: 'No Telp',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone number';
                        }
                        // You can add additional email validation here
                        return null;
                      },
                      readOnly: true,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Material(
                    elevation: 5,
                    borderRadius: BorderRadius.circular(10.0),
                    shadowColor: Colors.grey,
                    child: TextFormField(
                      maxLines: 8,
                      controller: _noteController,
                      decoration: InputDecoration(
                        labelText: 'Tuliskan paket yang Anda inginkan',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your Note';
                        }
                        // You can add additional email validation here
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        // _submitFormTrial(context);
                        _submitForm(context);
                      },
                      child: const Text('Request Upgrade'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Determine the current position of the device.
///
/// When the location services are not enabled or permissions
/// are denied the `Future` will return an error.
Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}
