import 'package:flutter/material.dart';
import 'package:idmall/models/product.dart';
import 'package:idmall/pages/form_suervey.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:idmall/config/config.dart' as config;
import 'package:idmall/config/google_api_key.dart' as googleKey;

class ProductList extends StatefulWidget {
  final double latitude;
  final double longitude;
  final String address;
  final String zipcode;
  const ProductList({
    super.key,
    required this.longitude,
    required this.latitude,
    required this.address,
    required this.zipcode,
  });

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  List<Product> apiData = [];

  @override
  void initState() {
    super.initState();
    getProductList();
  }

  Future<String?> getProvince() async {
    final dio = Dio();
    double lat = widget.latitude;
    double lng = widget.longitude;
    const apiKey = googleKey.googleApiKey;

    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$apiKey';

    final response = await dio.get(url);
    if (response.statusCode == 200) {
      final results = response.data['results'] as List;

      for (final result in results) {
        final addressComponents = result['address_components'] as List;
        for (final component in addressComponents) {
          final types = component['types'] as List;
          if (types.contains('administrative_area_level_1')) {
            return component['long_name'];
          }
        }
      }
    } else {
      throw Exception('Failed to load data');
    }

    return null;
  }

  Future<void> getProductList() async {
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token') ?? "";
    final dio = Dio();
    final province = await getProvince();
    String proviceName = province ?? "JABODETABEK";

    if (province == "Jakarta") {
      proviceName = "JABODETABEK";
    }

    final response = await dio.get(
      "${config.backendBaseUrlProd}/common/products",
      queryParameters: {
        "product_type": "NORMAL",
        "customer_type": "RETAIL",
        "region": proviceName
      },
      options: Options(headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
        "Cache-Control": "no-cache",
      }),
    );

    setState(() {
      apiData = (response.data['data'] as List)
          .map((ele) => Product.fromJson(ele))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product List'),
      ),
      body: RefreshIndicator(
        onRefresh: getProductList,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Broadband Home',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Image.asset(
                        'images/broadbandhome.png',
                        width: 235,
                        height: 235,
                      ),
                    ),
                  ],
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: apiData.length,
                itemBuilder: (context, index) {
                  final product = apiData[index];
                  return _buildCard(
                    tipe: product.name,
                    title: product.name,
                    price: product.price.toString(),
                    productCode: product.code.toString(),
                    details: [
                      'Dedicated support',
                      'Business-grade performance',
                      'Free modem rental'
                    ],
                    onPressed: () {},
                    imagePath: 'images/pakethome1.png',
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard({
    required String tipe,
    required String title,
    required String price,
    required String productCode,
    required List<String> details,
    required VoidCallback onPressed,
    required String imagePath,
  }) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: AspectRatio(
                    aspectRatio: 16 / 11,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: Image.asset(
                        imagePath,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                Row(
                  children: [
                    Text(
                      price,
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const Text(
                      '/bulan',
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: details.map((detail) {
                    return _buildFeatureRow(Icons.check_circle_outline, detail);
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16.0),
          Align(
            alignment: Alignment.center,
            child: FractionallySizedBox(
              widthFactor: 3 / 4,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (builder) => FormSurvey(
                        latitude: widget.latitude,
                        longitude: widget.longitude,
                        tipe: tipe,
                        price: price,
                        productCode: productCode,
                        address: widget.address,
                        zipcode: widget.zipcode,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
                child: const Text(
                  'Pilih Paket',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16.0),
        ],
      ),
    );
  }

  Widget _buildFeatureRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue, size: 24),
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14.0,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
