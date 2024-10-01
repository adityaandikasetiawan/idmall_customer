import 'dart:convert';
import 'dart:io';
import 'package:dio/io.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:idmall/models/customer_detail.dart';
import 'package:idmall/models/product.dart';
import 'package:idmall/models/zip_code.dart';
import 'package:idmall/consts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';

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
        _postalCodeType =
            "${jsonNya.zipCode} => ${jsonNya.district}, ${jsonNya.city}, ${jsonNya.province}";
        _selectedServiceType = "${jsonNya.service} => ${jsonNya.productName}";
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
  String? _selectedServiceType;
  String? _postalCodeType;
  File? _imageFile;
  String? _region;

  Future<void> _submitForm(context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    String formLongitude = _longitudeController.text;
    String formLatitude = _latitudeController.text;
    // File? file = _imageFile; // Access the selected file if needed;
    File? file = _imageFile;
    if (formLongitude != '') {
      longitude = double.parse(formLongitude);
    }
    if (formLatitude != '') {
      latitude = double.parse(formLatitude);
    }
    if (file != null) {
    } else {
      // Send form data and image
    }

    try {
      // Replace URL with your endpoint

      // Handle response
      return Navigator.of(context).pop();
    } catch (e) {
      // Handle error
    }
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
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Material(
                    elevation: 5,
                    borderRadius: BorderRadius.circular(10.0),
                    shadowColor: Colors.grey,
                    child: DropdownSearch<String>(
                      selectedItem: _postalCodeType,
                      asyncItems: (String filter) async {
                        (dio.httpClientAdapter as IOHttpClientAdapter)
                            .createHttpClient = () => HttpClient()
                          ..badCertificateCallback =
                              (X509Certificate cert, String host, int port) =>
                                  true;
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
                            list.add(
                                "$zipCodeNya => $kelurahan, $kota, $provinsi");
                          }
                          // print(model[0]);
                          return list;
                        } else {
                          return [];
                        }
                      },
                      dropdownDecoratorProps: DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                          labelText: 'Kode Pos',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      popupProps: const PopupProps.menu(
                        showSelectedItems: true,
                        isFilterOnline: true,
                        showSearchBox: true,
                        // disabledItemFn: (String s) => s.startsWith('I'),
                      ),
                      onChanged: (String? value) {
                        setState(() {
                          _postalCodeType = value;
                          _region = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a postal code';
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
                      controller: _longitudeController,
                      decoration: InputDecoration(
                        labelText: 'Longitude',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter customer longitude';
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
                      controller: _latitudeController,
                      decoration: InputDecoration(
                        labelText: 'Latitude',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter customer latitude';
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
                    child: DropdownSearch<String>(
                      selectedItem: _selectedServiceType,
                      asyncItems: (String filter) async {
                        (dio.httpClientAdapter as IOHttpClientAdapter)
                            .createHttpClient = () => HttpClient()
                          ..badCertificateCallback =
                              (X509Certificate cert, String host, int port) =>
                                  true;
                        var response = await dio.get(
                            "$linkLaravelAPI/entri-data/product",
                            queryParameters: {
                              "chars": filter,
                              "region": _region
                            },
                            options: Options(headers: {
                              HttpHeaders.authorizationHeader: token,
                            }));
                        if (jsonDecode(response.data)['status'] == 'success') {
                          var hasil = jsonDecode(response.data)['data'];
                          List<String> list = [];
                          for (var ele in hasil) {
                            var productModel = Product.fromJson(ele);
                            var productNya = productModel.code.toString();
                            var name = productModel.name.toString();
                            var category = productModel.category.toString();
                            var group = productModel.group.toString();
                            var price = productModel.price.toString();
                            var region = productModel.region.toString();
                            list.add(
                                "$productNya => $name, $category, $group, $region, $price");
                          }
                          return list;
                        } else {
                          return [];
                        }
                      },
                      dropdownDecoratorProps: DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                          labelText: 'Layanan',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      popupProps: const PopupProps.menu(
                        showSelectedItems: true,
                        isFilterOnline: true,
                        showSearchBox: true,
                      ),
                      items: const [],
                      onChanged: (String? value) {
                        setState(() {
                          _selectedServiceType = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a product';
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
                      maxLines: 8,
                      controller: _noteController,
                      decoration: InputDecoration(
                        labelText: 'Note',
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
