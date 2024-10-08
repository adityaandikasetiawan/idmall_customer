// ignore_for_file: prefer_typing_uninitialized_variables, library_prefixes, unused_field, avoid_print, empty_catches

import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:idmall/models/odp_list.dart';
import 'package:idmall/models/zip_code.dart';
import 'package:idmall/pages/form_suervey.dart';
import 'package:idmall/pages/gmaps_search_location.dart';
import 'package:idmall/config/config.dart' as config;
import 'package:idmall/pages/product.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MapSample extends StatefulWidget {
  final String? productCode;
  final String? productName;
  const MapSample({
    super.key,
    this.productCode,
    this.productName,
  });

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final TextEditingController _searchController = TextEditingController();
  GoogleMapController? _mapController;
  double _lat = 0;
  double _long = 0;
  String? address;
  String? realzipcode;
  List<ODPList> apiData = [];
  LatLng currentLocation = const LatLng(0, 0);
  final Set<Marker> _markers = {};
  bool isAllowed = false;
  Dio dio = Dio();

  @override
  void initState() {
    super.initState();
    getODPList();
    getCurrentLocation();
  }

  Future<void> _goToSelectedArea(
      double latitude, double longitude, String placeName) async {
    setState(() {
      _searchController.text = placeName;
      _markers.clear();
      _markers.add(
        Marker(
          markerId: MarkerId('$latitude,$longitude'),
          position: LatLng(latitude, longitude),
          infoWindow: InfoWindow(title: 'Location', snippet: placeName),
          icon: BitmapDescriptor.defaultMarker,
        ),
      );
    });

    await _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(latitude, longitude), zoom: 15),
      ),
    );
  }

  Future<void> _getFullPostalCode(String zipcode) async {
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token') ?? "";

    final response = await dio.get(
      "${config.backendBaseUrlProd}/region/zip-code?page=1&list_per_page=10",
      queryParameters: {
        "q_search": zipcode,
      },
      options: Options(
        headers: {
          "Content-Type": "application/json",
          "Cache-Control": "no-cache",
          "Authorization": "Bearer $token"
        },
      ),
    );
    var hasil = response.data['data'];
    var zipCodeModel = ZipCode.fromJson(hasil[0]);
    var zipCodeNya = zipCodeModel.zipCode.toString();
    var kelurahan = zipCodeModel.district;
    var kota = zipCodeModel.city;
    var provinsi = zipCodeModel.province;

    setState(() {
      realzipcode = "$zipCodeNya => $kelurahan, $kota, $provinsi";
    });
  }

  Future<void> getODPList() async {
    final dio = Dio();
    final response = await dio.get(
      "${config.backendBaseUrlProd}/region/odp?page=1&list_per_page=100",
      options: Options(headers: {
        "Content-Type": "application/json",
        "Cache-Control": "no-cache"
      }),
    );

    setState(() {
      apiData = (response.data['data'] as List)
          .map((ele) => ODPList.fromJson(ele))
          .toList();
    });
  }

  Set<Circle> _buildCircles() {
    return apiData.map(
      (data) {
        double latitude = double.tryParse(data.latitude.trim()) ?? 0;
        double longitude = double.tryParse(data.longitude.trim()) ?? 0;

        return Circle(
          circleId: CircleId("$latitude,$longitude"),
          center: LatLng(latitude, longitude),
          radius: 500.0,
          fillColor: Colors.blue.withOpacity(0.3),
          strokeColor: Colors.blue,
          strokeWidth: 2,
        );
      },
    ).toSet();
  }

  Future<void> getCurrentLocation() async {
    var status = await Permission.location.status;
    if (status.isDenied || status.isRestricted) {
      if (await Permission.location.request().isGranted) {
        _getCurrentLocationWithPermission();
      }
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    } else if (status.isGranted) {
      _getCurrentLocationWithPermission();
    }
  }

  Future<void> _getCurrentLocationWithPermission() async {
    setState(() {
      isAllowed = true;
    });

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    double latitude = position.latitude;
    double longitude = position.longitude;

    _lat = latitude;
    _long = longitude;

    setState(() {
      currentLocation = LatLng(latitude, longitude);
    });

    await _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(latitude, longitude), zoom: 15),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            if (isAllowed) {
              if (_searchController.text != "") {
                await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Success'),
                      content: const Text('Lanjut Entri Prospek'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            print(_searchController.text);
                            if (widget.productCode == null) {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (builder) => ProductList(
                                    latitude: _lat,
                                    longitude: _long,
                                    address: _searchController.text,
                                    zipcode: realzipcode!,
                                  ),
                                ),
                              );
                            } else {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (builder) => FormSurvey(
                                    latitude: _lat,
                                    longitude: _long,
                                    tipe: widget.productName!,
                                    price: "",
                                    productCode: widget.productCode!,
                                    address: _searchController.text,
                                    zipcode: realzipcode!,
                                  ),
                                ),
                              );
                            }
                          },
                          child: const Text('Lanjutkan'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Batal'),
                        ),
                      ],
                    );
                  },
                );
              } else {
                await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Warning'),
                      content:
                          const Text('Mohon isi lokasi sebelum melanjutkan'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Batal'),
                        ),
                      ],
                    );
                  },
                );
              }
            } else {
              openAppSettings();
            }
          },
          label: isAllowed
              ? const Text('Entri Prospek')
              : const Text("Enabled Location"),
          icon: const Icon(Icons.location_pin),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  GoogleMap(
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
                    onMapCreated: (controller) {
                      setState(
                        () {
                          _mapController = controller;
                        },
                      );
                    },
                    initialCameraPosition: CameraPosition(
                      target: currentLocation,
                      zoom: 15,
                    ),
                    circles: _buildCircles(),
                    markers: _markers,
                  ),
                  Positioned(
                    bottom: 100,
                    right: 10,
                    child: SizedBox(
                      width: 40,
                      height: 40,
                      child: FloatingActionButton(
                        onPressed: getCurrentLocation,
                        backgroundColor: Colors.white.withOpacity(0.8),
                        child: const Icon(Icons.my_location, size: 20),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 15.0,
                    left: 8.0,
                    right: 8.0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _searchController,
                        onTap: () async {
                          var result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SearchLocation(
                                placesName: _searchController.text,
                              ),
                            ),
                          );
                          if (result != null) {
                            double latitude = result['latitude'];
                            double longitude = result['longitude'];
                            String name = result['name'];
                            String zipcode = result['zipcode'] ?? "";

                            _lat = result['latitude'];
                            _long = result['longitude'];
                            address = result['name'];

                            _goToSelectedArea(latitude, longitude, name);
                            _getFullPostalCode(zipcode.toString());
                          }
                        },
                        decoration: const InputDecoration(
                          hintText: "Search Places...",
                          filled: true,
                          fillColor: Colors.white60,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(16.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
