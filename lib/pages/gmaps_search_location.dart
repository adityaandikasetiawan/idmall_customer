import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:idmall/config/config.dart' as config;
// ignore: library_prefixes
import 'package:idmall/config/google_api_key.dart' as googleKey;

import '../service/coverage_area.dart';

class SearchLocation extends StatefulWidget {
  final String placesName;
  const SearchLocation({super.key, required this.placesName});

  @override
  State<SearchLocation> createState() => _SearchLocationState();
}

class _SearchLocationState extends State<SearchLocation> {
  List<String> _predictions = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.placesName != "") {
      _searchController.text = widget.placesName;
    }
  }

  Future<void> _getAutocompleteResults(String pattern) async {
    Dio dio = Dio();
    const String apiKey = googleKey.googleApiKey;
    const String baseURL = config.googleAutocompleteUrl;
    final String inputParam = 'input=${Uri.encodeComponent(pattern)}';
    const String apiKeyParam = 'key=$apiKey';
    final String requestURL = '$baseURL?$inputParam&$apiKeyParam';

    try {
      if (pattern.isNotEmpty || widget.placesName != "") {
        final response = await dio.get(requestURL);

        setState(() {
          _predictions = (response.data['predictions'] as List)
              .map((prediction) => prediction['description'] as String)
              .toList();
        });
      }
    } catch (e) {
      print('Error fetching autocomplete results: $e');
    }
    print(_predictions);
  }

  Future<LatLng?> _getPlaceDetails(String placeName) async {
    const String apiKey = googleKey.googleApiKey;
    const String baseURL = config.googleGeolocationURL;
    final String addressParam = 'address=${Uri.encodeComponent(placeName)}';
    const String apiKeyParam = 'key=$apiKey';

    final String requestURL = '$baseURL?$addressParam&$apiKeyParam';

    try {
      final response = await dio.get(requestURL);

      // Ambil latitude dan longitude dari respons
      final double latitude =
          response.data['results'][0]['geometry']['location']['lat'];
      final double longitude =
          response.data['results'][0]['geometry']['location']['lng'];
      Navigator.pop(context,
          {'latitude': latitude, 'longitude': longitude, 'name': placeName});
    } catch (e) {
      print('Error fetching place details: $e');
    }
    return null;
  }

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Periksa apakah layanan lokasi diaktifkan
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Jika tidak diaktifkan, tampilkan pesan atau buka pengaturan lokasi
      // ...
      return Future.error('Location services are disabled.');
    }

    // Periksa apakah izin lokasi telah diberikan
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Jika izin ditolak, tampilkan pesan atau buka pengaturan izin
        // ...
        return Future.error('Location permissions are denied.');
      }
    }

    // Periksa apakah izin lokasi diberikan secara terbatas (hanya saat digunakan)
    if (permission == LocationPermission.deniedForever) {
      // Jika ditolak secara permanen, tampilkan pesan atau buka pengaturan izin
      // ...
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // Ambil posisi saat ini
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<String> getPlaceName(double latitude, double longitude) async {
    const apiKey = googleKey.googleApiKey;
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$apiKey';

    final dio = Dio();
    try {
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        final decodedData = response.data;
        final results = decodedData['results'];
        if (results.isNotEmpty) {
          return results[0]['formatted_address'];
        }
      }
    } catch (e) {
      print('Error getting place name: $e');
    }

    return 'Unknown place';
  }

  Future<Map<String, dynamic>> getCurrentLocation2() async {
    const apiKey = googleKey.googleApiKey;
    final url =
        'https://www.googleapis.com/geolocation/v1/geolocate?key=$apiKey';

    final dio = Dio();

    try {
      final response = await dio.post(url);

      if (response.statusCode == 200) {
        double latitude = response.data['location']['lat'];
        double longitude = response.data['location']['lng'];
        getPlaceName(latitude, longitude).then(
          (String placeName) => Navigator.pop(
            context,
            {'latitude': latitude, 'longitude': longitude, 'name': placeName},
          ),
        );
        return response.data['location'];
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
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: CircleAvatar(
            backgroundColor: Colors.grey[400],
            child: const Icon(
              Icons.location_on,
              size: 16,
            ),
          ),
        ),
        title: const Text(
          "Search Location",
          style: TextStyle(color: Colors.black54),
        ),
        actions: [
          CircleAvatar(
            backgroundColor: Colors.grey[400],
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.close),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Form(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: TextFormField(
                controller: _searchController,
                onChanged: (value) {
                  _getAutocompleteResults(value);
                },
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                    hintText: "Search your location...",
                    prefixIcon: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Icon(
                        Icons.location_pin,
                        color: Colors.grey[400],
                      ),
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        _searchController.clear();
                      },
                      icon: Icon(Icons.close),
                    )),
              ),
            ),
          ),
          Divider(
            height: 4,
            thickness: 4,
            color: Colors.grey[300],
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: ElevatedButton.icon(
              onPressed: () {
                getCurrentLocation2();
                // getCurrentLocation().then((Position position) {
                //   double latitude = position.latitude;
                //   double longitude = position.longitude;
                //   print(latitude);
                //   print(longitude);
                //   getPlaceName(latitude, longitude).then((String placeName) {
                //     print('Current location: $placeName');
                //   }).catchError((e) {
                //     print('Error getting place name: $e');
                //   });
                // }).catchError((e) {
                //   print(e);
                // });
              },
              icon: Icon(Icons.send),
              label: const Text("Use my current location"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[300],
                foregroundColor: Colors.grey[50],
                elevation: 0,
                fixedSize: const Size(double.infinity, 40),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
              ),
            ),
          ),
          Divider(
            height: 4,
            thickness: 4,
            color: Colors.grey[300],
          ),
          Expanded(
            child: ListView.builder(
              clipBehavior: Clip.none,
              itemCount: _predictions.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    ListTile(
                      title: Text(_predictions[index]),
                      onTap: () async {
                        _getPlaceDetails(_predictions[index]);
                        // _searchController.text = _predictions[index];
                        setState(() {
                          _predictions =
                              []; // Setel kembali daftar prediksi menjadi kosong
                        });
                      },
                    ),
                    Divider(
                      thickness: 2,
                      height: 2,
                      color: Colors.grey[300],
                    )
                  ],
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
