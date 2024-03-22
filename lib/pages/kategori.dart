import 'package:flutter/material.dart';
import 'package:idmall/pages/broadbandbisnis.dart';
import 'package:idmall/pages/broadbandhome.dart';
import 'package:idmall/pages/enterprisesolution.dart';
import 'package:idmall/widget/notificationpage.dart';
import 'package:idmall/widget/chatbotpage.dart';
import 'package:idmall/widget/shoppingchartpage.dart'; 

class CategoryPage extends StatelessWidget {
  const CategoryPage({Key? key}) : super(key: key);

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
                        builder: (context) => NotificationsPage(),
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
                            builder: (context) => NotificationsPage(),
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
                        builder: (context) => ChatbotPage(),
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
                            builder: (context) => ChatbotPage(),
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
                        builder: (context) => ShoppingCartPage(),
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
                      icon: Icon(Icons.shopping_cart),
                      color: const Color.fromARGB(255, 0, 0, 0),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ShoppingCartPage(),
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
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Kategori',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            _buildCard(
              title: 'Boardband Home',
              description: '5 Product',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BroadbandHomePage(), // Ganti dengan halaman tujuan yang diinginkan
                  ),
                );
              },
            ),
            SizedBox(height: 16.0),
            _buildCard(
              title: 'Boardband Bisnis',
              description: '4 Product',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BroadbandBisnisPage(), // Ganti dengan halaman tujuan yang diinginkan
                  ),
                );
              },
            ),
            SizedBox(height: 16.0),
            _buildCard(
              title: 'Enterprise Solution',
              description: '1 Product',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EnterpriseSolutionPage(), // Ganti dengan halaman tujuan yang diinginkan
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({required String title, required String description, required VoidCallback onPressed}) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                description,
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
