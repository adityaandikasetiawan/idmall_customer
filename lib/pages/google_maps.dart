// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:idmall/pages/gmaps_search_location.dart';
import 'package:idmall/pages/product.dart';

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

  Set<Circle> _buildCircles() {
    // Misal respons API berisi data koordinat lingkaran dalam format tertentu
    List<Map<String, dynamic>> apiData = [
      {"latitude": -6.2863449, "longitude": 106.9004588, "radius": 1000.00},
      {"latitude": 40.7128, "longitude": -74.0060, "radius": 1500.00},
      // Tambahkan data lain sesuai kebutuhan
    ];

    Set<Circle> circles = Set();

    // Loop melalui data API untuk membuat lingkaran
    apiData.forEach((data) {
      double latitude = data["latitude"];
      double longitude = data["longitude"];
      // double radius = double.parse(data["radius"]);

      Circle circle = Circle(
        circleId: CircleId("$latitude,$longitude"),
        center: LatLng(latitude, longitude),
        radius: 1000.0,
        fillColor: Colors.blue.withOpacity(0.3), // Atur warna isian lingkaran
        strokeColor: Colors.blue, // Atur warna tepi lingkaran
        strokeWidth: 2, // Atur lebar tepi lingkaran
      );

      circles.add(circle);
    });

    return circles;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Success'),
                content: Text('Lokasi Anda tercover'),
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
                    child: Text('Lanjutkan'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Batal'),
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
                  initialCameraPosition: const CameraPosition(
                    target: LatLng(0, 0),
                    zoom: 10,
                  ),
                  circles: _buildCircles(),
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
