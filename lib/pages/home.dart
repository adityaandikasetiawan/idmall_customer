import 'package:flutter/material.dart';
import 'package:idmall/pages/details.dart';
import 'package:idmall/service/database.dart';
import 'package:idmall/service/shared_preference_helper.dart';
import 'package:idmall/widget/button.dart';
import 'package:idmall/widget/widget_support.dart';
import 'package:idmall/widget/notificationpage.dart';
import 'package:idmall/widget/chatbotpage.dart';
import 'package:idmall/widget/shoppingchartpage.dart';
import 'package:idmall/pages/promotionpage.dart';
import 'package:idmall/pages/allmenu.dart';
import 'package:idmall/pages/gangguan.dart';
import 'package:idmall/pages/packagepage.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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

  Future<void> getthesharedpref() async {
    name = await SharedPreferenceHelper().getNameUser();
    if (mounted) {
      setState(() {});
    }
  }

  Stream? fooditemStream;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 250, 250, 255),
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
                          text: "${name ?? "Guest"}",
                          style: TextStyle(
                            fontSize: 18,
                            color: const Color.fromARGB(
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
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NotificationsPage()),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: const Color.fromARGB(255, 0, 0, 0)),
                          ),
                          child: IconButton(
                            icon: Icon(Icons.notifications),
                            color: const Color.fromARGB(255, 0, 0, 0),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => NotificationsPage()),
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
                                builder: (context) => ChatbotPage()),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                                color: const Color.fromARGB(255, 0, 0, 0)),
                          ),
                          child: IconButton(
                            icon: Image.asset('images/Chatbot.png',
                                width: 15, height: 15),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ChatbotPage()),
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
                                builder: (context) => ShoppingCartPage()),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: const Color.fromARGB(255, 0, 0, 0)),
                          ),
                          child: IconButton(
                            icon: Icon(Icons.shopping_cart),
                            color: const Color.fromARGB(255, 0, 0, 0),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ShoppingCartPage()),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20.0),
              Container(
                width: double.infinity * 2, // Sesuaikan lebar dengan kebutuhan
                height: 120, // Sesuaikan tinggi dengan kebutuhan
                child: Card(
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  color: Color.fromARGB(255, 19, 24,
                      84), // Mengubah warna background menjadi biru dongker
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset('images/point.png',
                                  width: 20,
                                  height: 20), // Menggunakan gambar untuk icon
                              SizedBox(
                                  height:
                                      8), // Tambahkan jarak antara icon dan teks
                              Text(
                                'Point',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Rp.100.000',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                            width:
                                20), // Tambahkan jarak horizontal di antara widget
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset('images/bill.png',
                                  width: 20,
                                  height: 20), // Menggunakan gambar untuk icon
                              SizedBox(
                                  height:
                                      8), // Tambahkan jarak antara icon dan teks
                              Text(
                                'Actual Bill',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Rp.100.000',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                            width:
                                20), // Tambahkan jarak horizontal di antara widget
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset('images/voucher.png',
                                  width: 20,
                                  height: 20), // Menggunakan gambar untuk icon
                              SizedBox(
                                  height:
                                      8), // Tambahkan jarak antara icon dan teks
                              Text(
                                'Voucher',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Rp.100.000',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // New Promotion Card
              Container(
                margin: EdgeInsets.symmetric(vertical: 20.0),
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
                        MaterialPageRoute(
                            builder: (context) =>
                                PromotionsPage()), // Memanggil halaman promosi
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'New Promotions!!!',
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
                                    color: Color.fromARGB(255, 228, 99, 7),
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 10.0),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child: Image.asset(
                              'images/card2.png',
                              fit: BoxFit.cover,
                              width: 150.0,
                              height: 150.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Three icons
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PackagesPage()),
                      );
                    },
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.black,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Image.asset(
                              'images/paket.png',
                              width: 20,
                              height: 20,
                              color: const Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Paket',
                          style: TextStyle(
                            color: const Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TroublePage()),
                      );
                    },
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.black,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Image.asset(
                              'images/gangguan.png',
                              width: 20,
                              height: 20,
                              color: const Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Gangguan',
                          style: TextStyle(
                            color: const Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AllPage()),
                      );
                    },
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.black,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Image.asset(
                              'images/semua.png',
                              width: 20,
                              height: 20,
                              color: const Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Semua',
                          style: TextStyle(
                            color: const Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // New Card
              Container(
                margin: EdgeInsets.symmetric(vertical: 20.0),
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
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Cek coverage is available!',
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
                            'images/coverange.png', // Ganti dengan path gambar yang sesuai
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: 2),
              // Carousel slides
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Text(
                        'Penawaran Terbaru',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                          width:
                              110), // Tambahkan jarak antara judul dan subjudul
                      Text(
                        'Lihat Semuanya',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color.fromARGB(255, 228, 99, 7),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                      height:
                          5), // Tambahkan jarak vertikal antara judul dan carousel
                  Container(
                    height: 280,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        buildCarouselItem(
                          title: 'Title 1',
                          price: 'Rp. 100.000',
                          imagePath: 'images/promo1.png',
                          backgroundColor: Color.fromARGB(255, 77, 77, 77),
                        ),
                        SizedBox(
                            width:
                                10), // Tambahkan jarak horizontal antara slide
                        buildCarouselItem(
                          title: 'Title 2',
                          price: 'Rp. 150.000',
                          imagePath: 'images/promo2.png',
                          backgroundColor: Color.fromARGB(255, 77, 77, 77),
                        ),
                        SizedBox(
                            width:
                                10), // Tambahkan jarak horizontal antara slide
                        buildCarouselItem(
                          title: 'Title 3',
                          price: 'Rp. 200.000',
                          imagePath: 'images/promo3.png',
                          backgroundColor: Color.fromARGB(255, 77, 77, 77),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCarouselItem({
    required String title,
    required String price,
    required String imagePath,
    required Color backgroundColor,
  }) {
    return Container(
      width: 200,
      margin: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: backgroundColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            imagePath,
            height: 150,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),
          Text(
            price,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 5),
          ElevatedButton(
            onPressed: () {
              // Action when button is pressed
            },
            child: Text('Tambah'),
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
      {Key? key, required this.icon, required this.text, required this.value})
      : super(key: key);

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
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
              fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
