// ignore_for_file: prefer_typing_uninitialized_variables, library_prefixes

import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:idmall/models/odp_list.dart';
import 'package:idmall/pages/gmaps_search_location.dart';
import 'package:idmall/pages/product.dart';
import 'package:idmall/config/config.dart' as config;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:idmall/config/google_api_key.dart' as googleKey;

class MapSample extends StatefulWidget {
  const MapSample({
    super.key,
  });

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final TextEditingController _searchController = TextEditingController();
  GoogleMapController? _mapController;
  double _lat = 0;
  double _long = 0;
  List<ODPList> apiData = [];
  LatLng currentLocation = const LatLng(0, 0);
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    getODPList();
    getCurrentLocation();
  }

  Future<void> _goToSelectedArea(latitude, longitude, placeName) async {
    try {
      setState(() {
        _searchController.text = placeName;
      });
      await _mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(latitude, longitude),
            zoom: 15,
          ),
        ),
      );
    } catch (e) {
      print('Error fetching autocomplete results: $e');
    }
  }

  Future<void> getODPList() async {
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token') ?? "";
    final dio = Dio();
    final response = await dio.get(
      "${config.backendBaseUrl}/region/odp?page=1&list_per_page=100",
      options: Options(headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      }),
    );
    for (var ele in response.data['data']) {
      apiData.add(ODPList.fromJson(ele));
    }

    setState(() {});
  }

  Set<Circle> _buildCircles() {
    Set<Circle> circles = {};

    // Loop melalui data API untuk membuat lingkaran
    for (var data in apiData) {
      double? latitude = double.tryParse(data.latitude.trim()) ?? 0;
      double? longitude = double.tryParse(data.longitude.trim()) ?? 0;
      // double radius = double.parse(data["radius"]);

      Circle circle = Circle(
        circleId: CircleId("$latitude,$longitude"),
        center: LatLng(latitude, longitude),
        radius: 800.0,
        fillColor: Colors.blue.withOpacity(0.3), // Atur warna isian lingkaran
        strokeColor: Colors.blue, // Atur warna tepi lingkaran
        strokeWidth: 2, // Atur lebar tepi lingkaran
      );

      circles.add(circle);
    }

    return circles;
  }

  Future<void> getCurrentLocation() async {
    const apiKey = googleKey.googleApiKey;
    const url =
        'https://www.googleapis.com/geolocation/v1/geolocate?key=$apiKey';

    final dio = Dio();

    try {
      final response = await dio.post(url);

      if (response.statusCode == 200) {
        double latitude = response.data['location']['lat'];
        double longitude = response.data['location']['lng'];

        _lat = latitude;
        _long = longitude;

        await _mapController?.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(latitude, longitude),
              zoom: 15,
            ),
          ),
        );

        setState(() {
          _markers.add(Marker(
            markerId: MarkerId('$latitude,$longitude'),
            position: LatLng(latitude, longitude),
            infoWindow: const InfoWindow(
              title: 'Your location',
              snippet: 'This is your current location',
            ),
            icon: BitmapDescriptor.defaultMarker,
          ));
        });
      } else {
        throw Exception('Failed to get current location');
      }
    } catch (e) {
      throw Exception('Failed to get current location: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          print(_lat);
          print(_long);
          await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Success'),
                content: const Text('Lokasi Anda tercover'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (builder) => ProductList(
                            latitude: _lat,
                            longitude: _long,
                          ),
                        ),
                      );
                      // FormSurvey(latitude: position.latitude, longitude: position.longitude,)));
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
        },
        label: const Text('Check Coverage'),
        icon: const Icon(Icons.location_pin),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                GoogleMap(
                  onMapCreated: (controller) {
                    setState(() {
                      _mapController = controller;
                    });
                  },
                  initialCameraPosition: CameraPosition(
                    target: currentLocation,
                    zoom: 10,
                  ),
                  circles: _buildCircles(),
                  markers: _markers, // Set marker pada peta
                ),
                Positioned(
                  top: 20.0,
                  left: 8.0,
                  right: 8.0,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _searchController,
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SearchLocation(
                              placesName: _searchController.text,
                            ),
                          ),
                        ).then((result) {
                          if (result != null) {
                            double latitude = result['latitude'];
                            double longitude = result['longitude'];
                            _lat = result['latitude'];
                            _long = result['longitude'];
                            String name = result['name'];
                            _goToSelectedArea(latitude, longitude, name);
                          }
                        });
                      },
                      decoration: const InputDecoration(
                        hintText: "Search Places...",
                        filled: true,
                        fillColor: Colors
                            .white60, // Setel warna latar belakang menjadi putih
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
    );
  }
}
