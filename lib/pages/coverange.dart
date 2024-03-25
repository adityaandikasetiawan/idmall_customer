import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:idmall/misc/tile_provider.dart';
import 'package:idmall/models/odp_list.dart';
import 'package:idmall/pages/form_suervey.dart';
import 'package:idmall/pages/product.dart';
import 'package:idmall/pages/survei.dart';
import 'package:idmall/service/coverage_area.dart';
import 'package:idmall/config/config.dart' as config;
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Coverage extends StatefulWidget {
  static const String route = '/';

  const Coverage({Key? key});

  @override
  State<Coverage> createState() => _CoverageState();
}

class _CoverageState extends State<Coverage> {
  double? latitu;
  double? longitu;
  late final customMarkers = <Marker>[];
  late final circleMarkers = <CircleMarker>[];

  Future getOdpList() async {
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token') ?? "";

    final dio = Dio();
    final response = await dio.get(
      '${config.backendBaseUrl}/region/odp?page=1&list_per_page=44',
      options: Options(headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      }),
    );

    for (var element in response.data['data']) {
      if (element['Latitude'] != "" && element['Latitude'] != null) {
        // final onpin = buildPin(
        //   LatLng(
        //     double.parse(element['Latitude']),
        //     double.parse(element['Longitude']),
        //   ),
        // );
        // customMarkers.add(onpin);

        final circle = CircleMarker(
          point: LatLng(
            double.parse(element['Latitude']),
            double.parse(element['Longitude']),
          ),
          color: Colors.green.withOpacity(0.7),
          borderColor: Colors.black,
          borderStrokeWidth: 2,
          useRadiusInMeter: true,
          radius: 300, // meters
        );
        circleMarkers.add(circle);
      }
    }

    print(customMarkers.length);
    print(circleMarkers.length);
  }

  Marker buildPin(LatLng point) => Marker(
        point: point,
        width: 60,
        height: 60,
        child: GestureDetector(
          onTap: () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Nama POP ID"),
              duration: Duration(seconds: 1),
              showCloseIcon: true,
            ),
          ),
          child: const Icon(Icons.location_pin, size: 20, color: Colors.red),
        ),
      );

  void showLocationSearch() async {
    String? searchQuery = await showDialog(
      context: context,
      builder: (BuildContext context) {
        String query = '';
        return AlertDialog(
          title: Text('Pencarian Lokasi'),
          content: TextFormField(
            onChanged: (value) {
              query = value;
            },
            decoration: InputDecoration(
              hintText: 'Masukkan lokasi',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(query);
              },
              child: Text('Cari'),
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

    if (searchQuery != null && searchQuery.isNotEmpty) {
      // Di sini Anda dapat menambahkan logika untuk mencari lokasi berdasarkan `searchQuery`
      // Misalnya, dengan menggunakan Google Places API atau sumber data lainnya.
      // Setelah mendapatkan lokasi, Anda bisa menambahkan marker baru ke peta.

      // Contoh: menambahkan marker ke lokasi yang ditemukan
      Position position = await _determinePosition();
      LatLng location = LatLng(position.latitude, position.latitude); // Ganti dengan koordinat yang ditemukan
      // customMarkers.add(buildPin(location));

      // Perbarui tampilan peta
      // setState(() {
      //   customMarkers.add(buildPin(location));
      // });
    }
  }

  void checkCoverage() async {
    Position? position = await _determinePosition();
    double? latitude;
    double? longitude;
    print(position);
    if (position.latitude != 0 && position.latitude != 0) {
      print('a');
      // Di sini Anda dapat menambahkan logika untuk mencari lokasi berdasarkan `searchQuery`
      // Misalnya, dengan menggunakan Google Places API atau sumber data lainnya.
      // Setelah mendapatkan lokasi, Anda bisa menambahkan marker baru ke peta.

      // Contoh: menambahkan marker ke lokasi yang ditemukan
      LatLng location = LatLng(position.latitude, position.longitude); // Ganti dengan koordinat yang ditemukan
      // customMarkers.add(buildPin(location));

      // Perbarui tampilan peta
      if (latitu != null && longitu != null) {
        latitude = latitu;
        longitude = longitu;
      }else {
        setState(() {
          customMarkers.add(Marker(
          point: location,
          width: 60,
          height: 60,
          child: GestureDetector(
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Lokasi anda sekarang"),
                duration: Duration(seconds: 1),
                showCloseIcon: true,
              ),
            ),
            child: const Icon(Icons.location_pin, size: 20, color: Colors.red),
          ),
        ));
        });
        latitude = position.latitude;
        longitude = position.longitude;
      }
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('Lokasi Anda tercover'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (builder) => 
                  ProductList(latitude: latitude!, longitude: longitude!,)));
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
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getOdpList();
  }

  @override
  Widget build(BuildContext context) {
    bool counterRotate = false;
    Alignment selectedAlignment = Alignment.topCenter;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Coverage Area',
          style: TextStyle(fontSize: 16),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              // Tambahkan fungsi untuk menampilkan petunjuk di sini
            },
            icon: Icon(Icons.help_outline),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 500,
                  child: FlutterMap(
                    options: MapOptions(
                      initialCenter: const LatLng(-6.200000, 106.816666),
                      initialZoom: 12,
                      cameraConstraint: CameraConstraint.contain(
                        bounds: LatLngBounds(
                          const LatLng(-90, -180),
                          const LatLng(90, 180),
                        ),
                      ),
                      onTap: _handleTap,
                      interactionOptions: InteractionOptions(
                        enableScrollWheel: true,
                        flags: InteractiveFlag.all,
                      ),
                    ),
                    children: [
                      openStreetMapTileLayer,
                      MarkerLayer(markers: customMarkers),
                      CircleLayer(
                        circles: circleMarkers,
                      ),

                    ],
                  ),
                ),
              ],
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              transform: Matrix4.translationValues(0.0, -40.0, 0.0),
              padding: EdgeInsets.only(left: 15, right: 15, top: 40, bottom: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: checkCoverage,
                    child: Text('Cek Coverage')
                  ),
                  SizedBox(height: 100,),
                ],
              ),
            )
          ]
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 100.0),
        child: FloatingActionButton(
          onPressed: showLocationSearch,
          tooltip: 'Cari Lokasi',
          child: Icon(Icons.search),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
    );
  }
  void _handleTap(TapPosition tapPos, LatLng latlng) {
    setState(() {
      latitu = latlng.latitude;
      longitu = latlng.longitude;
      customMarkers.clear(); // Menghapus marker sebelumnya
      customMarkers.add(
        Marker(
          point: latlng,
          width: 60,
          height: 60,
          child: GestureDetector(
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Lokasi yang Anda Pilih"),
                duration: Duration(seconds: 1),
                showCloseIcon: true,
              ),
            ),
            child: const Icon(Icons.location_pin, size: 20, color: Colors.red),
          ),
      ),
      );
    });
  }
}

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