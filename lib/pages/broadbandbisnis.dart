import 'package:flutter/material.dart';
import 'package:idmall/pages/broadbandhome.dart';
import 'package:idmall/pages/enterprisesolution.dart';
import 'package:idmall/widget/notificationpage.dart';
import 'package:idmall/widget/chatbotpage.dart';
import 'package:idmall/widget/shoppingchartpage.dart';

class BroadbandBisnisPage extends StatelessWidget {
  const BroadbandBisnisPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NotificationPage(),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: Colors.black,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                        BoxShadow(
                          color: Color.fromARGB(255, 255, 255, 255),
                          spreadRadius: 7.0,
                          blurRadius: 12.0,
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.notifications),
                      color: const Color.fromARGB(255, 0, 0, 0),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NotificationPage(),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChatbotPage(),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: Colors.black,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                        BoxShadow(
                          color: Color.fromARGB(255, 255, 255, 255),
                          spreadRadius: 7.0,
                          blurRadius: 12.0,
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: Image.asset('images/widget/Chatbot.png',
                          width: 15, height: 15),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ChatbotPage(),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ShoppingCartPage(),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: Colors.black,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                        BoxShadow(
                          color: Color.fromARGB(255, 255, 255, 255),
                          spreadRadius: 7.0,
                          blurRadius: 12.0,
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.shopping_cart),
                      color: const Color.fromARGB(255, 0, 0, 0),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ShoppingCartPage(),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
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
                      'Broadband\nBisnis',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: Image.asset(
                      'images/broadbandbisnis.png', // Ganti dengan path gambar yang diinginkan
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
              title: 'BroadBand  Home 10 Mb',
              price: 'Rp 179.000',
              details: [
                'Unlimited data',
                '100 Mbps speed',
                'Free installation'
              ],
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const BroadbandHomePage(), // Ganti dengan halaman tujuan yang diinginkan
                  ),
                );
              },
              imagePath:
                  'images/paketbisnis.png', // Ganti dengan path gambar yang diinginkan
            ),
            const SizedBox(height: 16.0),
            _buildCard(
              title: 'BroadBand  Home 20 Mb',
              price: 'Rp 239.000',
              details: [
                'Dedicated support',
                'Business-grade performance',
                'Free modem rental'
              ],
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const BroadbandBisnisPage(), // Ganti dengan halaman tujuan yang diinginkan
                  ),
                );
              },
              imagePath:
                  'images/paketbisnis.png', // Ganti dengan path gambar yang diinginkan
            ),
            const SizedBox(height: 16.0),
            _buildCard(
              title: 'BroadBand  Home 50 Mb',
              price: 'Rp 299.000',
              details: [
                'Customized solutions',
                'for large enterprises',
                '24/7 customer support'
              ],
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const EnterpriseSolutionPage(), // Ganti dengan halaman tujuan yang diinginkan
                  ),
                );
              },
              imagePath:
                  'images/paketbisnis.png', // Ganti dengan path gambar yang diinginkan
            ),
            const SizedBox(height: 16.0),
            _buildCard(
              title: 'BroadBand  Home 100 Mb',
              price: 'Rp 369.000',
              details: [
                'High-speed internet',
                'for heavy users',
                'Free router upgrade'
              ],
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const EnterpriseSolutionPage(), // Ganti dengan halaman tujuan yang diinginkan
                  ),
                );
              },
              imagePath:
                  'images/paketbisnis.png', // Ganti dengan path gambar yang diinginkan
            ),
            const SizedBox(height: 16.0),
            _buildCard(
              title: 'BroadBand  Home 200 Mb',
              price: 'Rp 569.000',
              details: [
                'Maximum speed',
                'and performance',
                'Free installation'
              ],
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const EnterpriseSolutionPage(), // Ganti dengan halaman tujuan yang diinginkan
                  ),
                );
              },
              imagePath:
                  'images/paketbisnis.png', // Ganti dengan path gambar yang diinginkan
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({
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
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              InkWell(
                onTap: onPressed,
                child: Padding(
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
                          return _buildFeatureRow(
                              Icons.check_circle_outline, detail);
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Align(
                alignment: Alignment.center,
                child: FractionallySizedBox(
                  widthFactor: 3 / 4,
                  child: ElevatedButton(
                    onPressed: onPressed,
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
        ),
      ),
    );
  }

  Widget _buildFeatureRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon,
              color: Colors.blue, size: 24), // Perbesar ukuran ikon menjadi 24
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

void main() {
  runApp(const MaterialApp(
    home: BroadbandHomePage(),
  ));
}
