import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:idmall/misc/tile_provider.dart';
import 'package:idmall/models/odp_list.dart';
import 'package:idmall/service/coverage_area.dart';
import 'package:idmall/config/config.dart' as config;
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Coverage extends StatefulWidget {
  static const String route = '/';

  const Coverage({super.key});

  @override
  State<Coverage> createState() => _CoverageState();
}

class _CoverageState extends State<Coverage> {
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
        final onpin = buildPin(
          LatLng(
            double.parse(element['Latitude']),
            double.parse(element['Longitude']),
          ),
        );
        customMarkers.add(onpin);

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

  @override
  Widget build(BuildContext context) {
    getOdpList();
    bool counterRotate = false;
    Alignment selectedAlignment = Alignment.topCenter;

    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
                initialCenter: const LatLng(-6.200000, 106.816666),
                initialZoom: 12,
                cameraConstraint: CameraConstraint.contain(
                  bounds: LatLngBounds(
                    const LatLng(-90, -180),
                    const LatLng(90, 180),
                  ),
                ),
                interactionOptions: InteractionOptions(
                  enableScrollWheel: true,
                  flags: InteractiveFlag.all,
                )),
            children: [
              openStreetMapTileLayer,
              // MarkerLayer(
              //   markers: customMarkers,
              //   rotate: counterRotate,
              //   alignment: selectedAlignment,
              // ),
              CircleLayer(
                circles: circleMarkers,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
