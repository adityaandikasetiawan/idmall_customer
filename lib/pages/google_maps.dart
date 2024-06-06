// ignore_for_file: prefer_typing_uninitialized_variables, library_prefixes, empty_catches, use_build_context_synchronously

import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:idmall/models/odp_list.dart';
import 'package:idmall/pages/gmaps_search_location.dart';
import 'package:idmall/pages/product.dart';
import 'package:idmall/config/config.dart' as config;
import 'package:permission_handler/permission_handler.dart';
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
  bool isAllowed = false;

  @override
  void initState() {
    super.initState();
    getODPList();
    getCurrentLocation();
  }

  Future<void> _goToSelectedArea(latitude, longitude, placeName) async {
    try {
      setState(
        () {
          _searchController.text = placeName;
          _markers.clear();
          _markers.add(
            Marker(
              markerId: MarkerId('$latitude,$longitude'),
              position: LatLng(latitude, longitude),
              infoWindow: InfoWindow(
                title: 'Location',
                snippet: placeName,
              ),
              icon: BitmapDescriptor.defaultMarker,
            ),
          );
        },
      );

      await _mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(latitude, longitude),
            zoom: 15,
          ),
        ),
      );
    } catch (e) {}
  }

  Future<void> getODPList() async {
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token') ?? "";
    final dio = Dio();
    final response = await dio.get(
      "${config.backendBaseUrlProd}/region/odp?page=1&list_per_page=100",
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
    var status = await Permission.location.status;
    if (status.isDenied || status.isRestricted) {
      if (await Permission.location.request().isGranted) {
        // Izin diberikan
        setState(() {
          isAllowed = true;
        });

        const apiKey = googleKey.googleApiKey;
        const url =
            'https://www.googleapis.com/geolocation/v1/geolocate?key=$apiKey';

        final dio = Dio();
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);

        try {
          final response = await dio.post(url);

          if (response.statusCode == 200) {
            // double latitude = response.data['location']['lat'];
            // double longitude = response.data['location']['lng'];

            double latitude = position.latitude;
            double longitude = position.longitude;

            _lat = latitude;
            _long = longitude;

            setState(() {
              currentLocation = LatLng(latitude, longitude);

              // _markers.add(Marker(
              //   markerId: MarkerId('$latitude,$longitude'),
              //   position: LatLng(latitude, longitude),
              //   infoWindow: const InfoWindow(
              //     title: 'Your location',
              //     snippet: 'This is your current location',
              //   ),
              //   icon: BitmapDescriptor.defaultMarker,
              // ));
            });

            await _mapController?.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(
                  target: LatLng(latitude, longitude),
                  zoom: 15,
                ),
              ),
            );
          } else {
            throw Exception('Failed to get current location');
          }
        } catch (e) {
          throw Exception('Failed to get current location: $e');
        }
      }
    } else if (status.isPermanentlyDenied) {
      // Pengguna telah secara permanen menolak izin, mungkin perlu membimbing mereka ke pengaturan aplikasi
      openAppSettings();
    } else if (status.isGranted) {
      setState(() {
        isAllowed = true;
      });
      const apiKey = googleKey.googleApiKey;
      const url =
          'https://www.googleapis.com/geolocation/v1/geolocate?key=$apiKey';

      final dio = Dio();
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      try {
        final response = await dio.post(url);

        if (response.statusCode == 200) {
          double latitude = position.latitude;
          double longitude = position.longitude;

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
            currentLocation = LatLng(latitude, longitude);

            // _markers.add(Marker(
            //   markerId: MarkerId('$latitude,$longitude'),
            //   position: LatLng(latitude, longitude),
            //   infoWindow: const InfoWindow(
            //     title: 'Your location',
            //     snippet: 'This is your current location',
            //   ),
            //   icon: BitmapDescriptor.defaultMarker,
            // ));
          });
        } else {
          throw Exception('Failed to get current location');
        }
      } catch (e) {
        throw Exception('Failed to get current location: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            if (isAllowed) {
              final prefs = await SharedPreferences.getInstance();
              final String token = prefs.getString('token') ?? "";
              try {
                final dio = Dio();
                final response = await dio.get(
                  "${config.backendBaseUrlProd}/region/check_coverage",
                  queryParameters: {'longitude': _long, 'latitude': _lat},
                  options: Options(headers: {
                    "Content-Type": "application/json",
                    "Authorization": "Bearer $token"
                  }),
                );
                if (response.statusCode == 200) {
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
                }
              } on DioException catch (e) {
                // print(e.response?.data);
                await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Maaf'),
                      content: Text(e.response?.data['errors']['message'] ??
                          "Maaf terjadi kesalahan"),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('OK'),
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
          label: isAllowed == true
              ? const Text('Check Coverage')
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
                    bottom: 100,
                    right: 10,
                    child: SizedBox(
                      width: 40,
                      height: 40,
                      child: FloatingActionButton(
                        onPressed: getCurrentLocation,
                        backgroundColor: Colors.white.withOpacity(0.8),
                        child: const Icon(
                          Icons.my_location,
                          size: 20,
                        ),
                      ),
                    ),
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
      ),
    );
  }
}
