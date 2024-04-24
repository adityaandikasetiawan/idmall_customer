import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:idmall/pages/details.dart';
import 'package:idmall/pages/login.dart';
// ignore: unused_import
import 'package:idmall/service/database.dart';
// ignore: unused_import
import 'package:idmall/widget/button.dart';
import 'package:idmall/widget/widget_support.dart';
import 'package:idmall/pages/promo.dart';
import 'package:idmall/pages/coverange.dart';
import 'package:idmall/widget/penawaranterbaru.dart';

class DashboardGuest extends StatefulWidget {
  const DashboardGuest({super.key});

  @override
  State<DashboardGuest> createState() => _DashboardGuestState();
}

class _DashboardGuestState extends State<DashboardGuest> {
  String? name;
  String greeting = '';
  String points = '10';
  String billing = 'Rp 179.000';
  String vouchers = '1';

  @override
  void initState() {
    super.initState();
    setGreeting();
  }

  void setGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      setState(() {
        greeting = 'Pagi';
      });
    } else if (hour < 18) {
      setState(() {
        greeting = 'Siang';
      });
    } else {
      setState(() {
        greeting = 'Malam';
      });
    }
  }

  // Future<void> getthesharedpref() async {
  //   name = await SharedPreferenceHelper().getNameUser();
  //   if (mounted) {
  //     setState(() {});
  //   }
  // }

  Stream? fooditemStream;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 250, 255),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          margin: const EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "$greeting, ",
                          style: AppWidget.boldTextFeildStyle().copyWith(
                            color: Colors.black, // Menambahkan warna hitam
                          ),
                        ),
                        TextSpan(
                          text: name ?? "Guest",
                          style: const TextStyle(
                            fontSize: 18,
                            color: Color.fromARGB(
                                255, 0, 0, 0), // Ubah warna sesuai kebutuhan
                            fontFamily:
                                'Poppins', // Sesuaikan dengan gaya font yang Anda gunakan
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      ElevatedButton(
                        style: TextButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 228, 99, 7),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Login()),
                          );
                        },
                        child: const Text(
                          'Sign In',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // New Promotion Card
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20.0),
                child: Card(
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  color: const Color.fromARGB(255, 19, 24, 84),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20.0),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PromoPage()),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'New Promotions !!!',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 10.0),
                                Text(
                                  'Learn More',
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 228, 99, 7),
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: Image.asset(
                                'images/card2.png',
                                fit: BoxFit.cover,
                                width: 150.0,
                                height: 150.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // New Card
              SizedBox(
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Coverage()),
                    );
                  },
                  child: Card(
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    color: const Color.fromARGB(255, 19, 24,
                        84), // Ubah warna latar belakang kartu menjadi biru tua
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Check Coverage',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors
                                        .white, // Ubah warna teks menjadi putih
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Image.asset(
                              'images/coverange.png', // Perhatikan penulisan nama gambar
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
              // Carousel slides
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Penawaran Terbaru',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // const SizedBox(
                      //   width: 150,
                      // ),
                      GestureDetector(
                        onTap: () {
                          // Navigasi ke halaman yang diinginkan
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const PenawaranPage()), // Ganti dengan halaman yang diinginkan
                          );
                        },
                        child: const Text(
                          'Lihat Semuanya',
                          style: TextStyle(
                            fontSize: 10,
                            color: Color.fromARGB(255, 228, 99, 7),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                      height:
                          5), // Tambahkan jarak vertikal antara judul dan carousel
                  SizedBox(
                    height: 280,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const DetailPage(
                                  title: 'IdPlay Home',
                                  price: 'Rp. 179.000',
                                  imagePath: 'images/promo1.png',
                                ),
                              ),
                            );
                          },
                          child: buildRoundedCarouselItem(
                            title: 'IdPlay Home',
                            price: 'Rp. 179.000',
                            imagePath: 'images/promo1.png',
                            backgroundColor:
                                const Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ), // Tambahkan jarak horizontal antara slide
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const DetailPage(
                                  title: 'IdPlay Home',
                                  price: 'Rp. 230.000',
                                  imagePath: 'images/promo2.png',
                                ),
                              ),
                            );
                          },
                          child: buildRoundedCarouselItem(
                            title: 'IdPlay Home',
                            price: 'Rp. 230.000',
                            imagePath: 'images/promo2.png',
                            backgroundColor:
                                const Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ), // Tambahkan jarak horizontal antara slide
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const DetailPage(
                                  title: 'IdPlay Home',
                                  price: 'Rp. 270.000',
                                  imagePath: 'images/promo3.png',
                                ),
                              ),
                            );
                          },
                          child: buildRoundedCarouselItem(
                            title: 'IdPlay Home',
                            price: 'Rp. 270.000',
                            imagePath: 'images/promo3.png',
                            backgroundColor:
                                const Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildRoundedCarouselItem({
    required String title,
    required String price,
    required String imagePath,
    required Color backgroundColor,
  }) {
    return Container(
      width: 200,
      margin: const EdgeInsets.symmetric(horizontal: 1),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30), // Rounded corners
        color: backgroundColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            // Rounded image
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              imagePath,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            price,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class CardWidgetWithIcon extends StatelessWidget {
  final IconData icon;
  final String text;
  final String value;

  const CardWidgetWithIcon(
      {super.key, required this.icon, required this.text, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.black),
            const SizedBox(width: 8),
            Text(
              text,
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
              fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
