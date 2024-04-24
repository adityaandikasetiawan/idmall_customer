import 'package:flutter/material.dart';
import 'package:idmall/pages/form_suervey.dart';

class ProductList extends StatefulWidget {
  final double latitude;
  final double longitude;
  const ProductList(
      {super.key, required this.longitude, required this.latitude});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product List'),
        // actions: [
        //   Padding(
        //     padding: const EdgeInsets.only(right: 20.0),
        //     child: Row(
        //       children: [
        //         GestureDetector(
        //           onTap: () {
        //             Navigator.push(
        //               context,
        //               MaterialPageRoute(
        //                 builder: (context) => NotificationsPage(),
        //               ),
        //             );
        //           },
        //           child: Container(
        //             decoration: BoxDecoration(
        //               borderRadius: BorderRadius.circular(15),
        //               border: Border.all(
        //                 color: Colors.black,
        //               ),
        //               color: Colors.transparent,
        //             ),
        //             child: IconButton(
        //               icon: const Icon(Icons.notifications),
        //               color: const Color.fromARGB(255, 0, 0, 0),
        //               onPressed: () {
        //                 Navigator.push(
        //                   context,
        //                   MaterialPageRoute(
        //                     builder: (context) => NotificationsPage(),
        //                   ),
        //                 );
        //               },
        //             ),
        //           ),
        //         ),
        //         const SizedBox(width: 10),
        //         GestureDetector(
        //           onTap: () {
        //             Navigator.push(
        //               context,
        //               MaterialPageRoute(
        //                 builder: (context) => ChatbotPage(),
        //               ),
        //             );
        //           },
        //           child: Container(
        //             decoration: BoxDecoration(
        //               borderRadius: BorderRadius.circular(15),
        //               border: Border.all(
        //                 color: Colors.black,
        //               ),
        //             ),
        //             child: IconButton(
        //               icon: Image.asset('images/widget/Chatbot.png',
        //                   width: 15, height: 15),
        //               onPressed: () {
        //                 Navigator.push(
        //                   context,
        //                   MaterialPageRoute(
        //                     builder: (context) => ChatbotPage(),
        //                   ),
        //                 );
        //               },
        //             ),
        //           ),
        //         ),
        //         const SizedBox(width: 10),
        //         GestureDetector(
        //           onTap: () {
        //             Navigator.push(
        //               context,
        //               MaterialPageRoute(
        //                 builder: (context) => ShoppingCartPage(),
        //               ),
        //             );
        //           },
        //           child: Container(
        //             decoration: BoxDecoration(
        //               borderRadius: BorderRadius.circular(15),
        //               border: Border.all(
        //                 color: Colors.black,
        //               ),
        //             ),
        //             child: IconButton(
        //               icon: Icon(Icons.shopping_cart),
        //               color: const Color.fromARGB(255, 0, 0, 0),
        //               onPressed: () {
        //                 Navigator.push(
        //                   context,
        //                   MaterialPageRoute(
        //                     builder: (context) => ShoppingCartPage(),
        //                   ),
        //                 );
        //               },
        //             ),
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ],
      ),
      body: SingleChildScrollView(
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
                      'images/broadbandhome.png', // Ganti dengan path gambar yang diinginkan
                      width:
                          235, // Sesuaikan dengan ukuran gambar yang diinginkan
                      height:
                          235, // Sesuaikan dengan ukuran gambar yang diinginkan
                    ),
                  ),
                ],
              ),
            ),
            _buildCard(
              tipe: 'idplay Retail Up To 10 Mbps',
              title: 'BroadBand  Home 10 Mb',
              price: 'Rp 179.000',
              details: ['Unlimited data', '10 Mbps speed', 'Free installation'],
              onPressed: () {},
              imagePath:
                  'images/pakethome1.png', // Ganti dengan path gambar yang diinginkan
            ),
            const SizedBox(height: 16.0),
            _buildCard(
              tipe: 'idplay Retail Up To 20 Mbps',
              title: 'BroadBand  Home 20 Mb',
              price: 'Rp 239.000',
              details: [
                'Dedicated support',
                'Business-grade performance',
                'Free modem rental'
              ],
              onPressed: () {},
              imagePath:
                  'images/pakethome1.png', // Ganti dengan path gambar yang diinginkan
            ),
            const SizedBox(height: 16.0),
            _buildCard(
              tipe: 'idplay Retail Up To 50 Mbps',
              title: 'BroadBand  Home 50 Mb',
              price: 'Rp 299.000',
              details: [
                'Customized solutions',
                'for large enterprises',
                '24/7 customer support'
              ],
              onPressed: () {},
              imagePath:
                  'images/pakethome1.png', // Ganti dengan path gambar yang diinginkan
            ),
            const SizedBox(height: 16.0),
            _buildCard(
              tipe: 'idplay Retail Up To 100 Mbps',
              title: 'BroadBand  Home 100 Mb',
              price: 'Rp 369.000',
              details: [
                'High-speed internet',
                'for heavy users',
                'Free router upgrade'
              ],
              onPressed: () {},
              imagePath:
                  'images/pakethome1.png', // Ganti dengan path gambar yang diinginkan
            ),
            const SizedBox(height: 16.0),
            _buildCard(
              tipe: 'idplay Retail Up To 200 Mbps',
              title: 'BroadBand  Home 200 Mb',
              price: 'Rp 569.000',
              details: [
                'Maximum speed',
                'and performance',
                'Free installation'
              ],
              onPressed: () {},
              imagePath:
                  'images/pakethome1.png', // Ganti dengan path gambar yang diinginkan
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({
    required String tipe,
    required String title,
    required String price,
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
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (builder) => FormSurvey(
                            latitude: widget.latitude,
                            longitude: widget.longitude,
                            tipe: tipe,
                            price: price,
                          )));
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
