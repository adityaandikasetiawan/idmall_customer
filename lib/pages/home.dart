import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:idmall/pages/details.dart';
import 'package:idmall/pages/google_maps.dart';
import 'package:idmall/pages/invoice.dart';
import 'package:idmall/pages/invoice_testing.dart';
import 'package:idmall/service/coverage_area.dart';
// ignore: unused_import
import 'package:idmall/service/database.dart';
// ignore: unused_import
import 'package:idmall/widget/button.dart';
import 'package:idmall/widget/widget_support.dart';
import 'package:idmall/widget/notificationpage.dart';
import 'package:idmall/widget/chatbotpage.dart';
import 'package:idmall/pages/promo.dart';
import 'package:idmall/pages/coverange.dart';
import 'package:idmall/widget/penawaranterbaru.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:idmall/config/config.dart' as config;
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? name;
  String greeting = '';
  String points = '10';
  String vouchers = '1';
  String? billing = "";
  String? package = "";
  String? customerID = "";
  String? status = "";
  final oCcy = NumberFormat("#,##0", "en_US");

  @override
  void initState() {
    super.initState();
    setGreeting();
    getUserName();
    dashboardData();
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

  Future<void> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('fullName') ?? "";
    });
  }

  Future<void> dashboardData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String token = prefs.getString('token') ?? "";

      final response = await dio.get(
        "${config.backendBaseUrl}/customer/billing/active",
        options: Options(headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        }),
      );
      setState(() {
        package = response.data['data']['Sub_Product'] ?? "";
        customerID = response.data['data']['Task_ID'] ?? "";
        billing = oCcy.format(response.data['data']['Monthly_Price']);
        status = response.data['data']['Status'] ?? "";
      });
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "$greeting, ",
                        style: AppWidget.boldTextFeildStyle()
                            .copyWith(color: Colors.black, fontSize: 15),
                      ),
                      TextSpan(
                        text: name ?? "Guest",
                        style: const TextStyle(
                          fontSize: 15,
                          color: Color.fromARGB(
                              255, 0, 0, 0), // Ubah warna sesuai kebutuhan
                          fontFamily:
                              'Poppins', // Sesuaikan dengan gaya font yang Anda gunakan
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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
                              builder: (context) => NotificationsPage()),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {},
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
                        builder: (context) => Invoice(
                          code: "",
                          totalPrice: 0,
                          taskID: customerID ?? "",
                        ),
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
                            builder: (context) => InvoicePage(
                              total: "",
                              bankName: "0",
                              taskid: customerID ?? "",
                              typePayment: "",
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 250, 250, 255),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          margin: const EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //card billing, point, etc
              status == "ACTIVE" || status == "DU" || status == "FREEZE"
                  ? SizedBox(
                      width: double.infinity *
                          2, // Sesuaikan lebar dengan kebutuhan
                      height: 120, // Sesuaikan tinggi dengan kebutuhan
                      child: Card(
                        elevation: 4.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        color: const Color.fromARGB(255, 19, 24,
                            84), // Mengubah warna background menjadi biru dongker
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Customer ID : $customerID",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                              Text(
                                "Paket            : $package",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                              Text(
                                "Status           : $status",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                              Text(
                                "Billing           : $billing",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  : SizedBox(),

              // const SizedBox(height: 20.0),
              // //card billing, point, etc
              // SizedBox(
              //   width: double.infinity * 2, // Sesuaikan lebar dengan kebutuhan
              //   height: 120, // Sesuaikan tinggi dengan kebutuhan
              //   child: Card(
              //     elevation: 4.0,
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(20.0),
              //     ),
              //     color: const Color.fromARGB(255, 19, 24,
              //         84), // Mengubah warna background menjadi biru dongker
              //     child: Padding(
              //       padding: const EdgeInsets.all(18.0),
              //       child: Row(
              //         children: [
              //           Expanded(
              //             child: Column(
              //               crossAxisAlignment: CrossAxisAlignment.center,
              //               children: [
              //                 Image.asset('images/widget/point.png',
              //                     width: 20,
              //                     height: 20), // Menggunakan gambar untuk icon
              //                 const SizedBox(
              //                     height:
              //                         8), // Tambahkan jarak antara icon dan teks
              //                 const Text(
              //                   'Point',
              //                   style: TextStyle(
              //                     color: Colors.white,
              //                     fontSize: 16,
              //                     fontWeight: FontWeight.bold,
              //                   ),
              //                 ),
              //                 const Text(
              //                   'Rp.100.000',
              //                   style: TextStyle(
              //                     color: Colors.white,
              //                     fontSize: 12,
              //                   ),
              //                 ),
              //               ],
              //             ),
              //           ),
              //           const SizedBox(
              //               width:
              //                   20), // Tambahkan jarak horizontal di antara widget
              //           Expanded(
              //             child: Column(
              //               crossAxisAlignment: CrossAxisAlignment.center,
              //               children: [
              //                 Image.asset('images/widget/bill.png',
              //                     width: 20,
              //                     height: 20), // Menggunakan gambar untuk icon
              //                 const SizedBox(
              //                     height:
              //                         8), // Tambahkan jarak antara icon dan teks
              //                 const Text(
              //                   'Actual Bill',
              //                   style: TextStyle(
              //                     color: Colors.white,
              //                     fontSize: 16,
              //                     fontWeight: FontWeight.bold,
              //                   ),
              //                 ),
              //                 const Text(
              //                   'Rp.100.000',
              //                   style: TextStyle(
              //                     color: Colors.white,
              //                     fontSize: 12,
              //                   ),
              //                 ),
              //               ],
              //             ),
              //           ),
              //           const SizedBox(
              //               width:
              //                   20), // Tambahkan jarak horizontal di antara widget
              //           Expanded(
              //             child: Column(
              //               crossAxisAlignment: CrossAxisAlignment.center,
              //               children: [
              //                 Image.asset('images/widget/voucher.png',
              //                     width: 20,
              //                     height: 20), // Menggunakan gambar untuk icon
              //                 const SizedBox(
              //                     height:
              //                         8), // Tambahkan jarak antara icon dan teks
              //                 const Text(
              //                   'Voucher',
              //                   style: TextStyle(
              //                     color: Colors.white,
              //                     fontSize: 16,
              //                     fontWeight: FontWeight.bold,
              //                   ),
              //                 ),
              //                 const Text(
              //                   'Rp.100.000',
              //                   style: TextStyle(
              //                     color: Colors.white,
              //                     fontSize: 12,
              //                   ),
              //                 ),
              //               ],
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),

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

              // // Three icons
              // SizedBox(height: 20),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //   children: [
              //     GestureDetector(
              //       onTap: () {
              //         Navigator.push(
              //           context,
              //           MaterialPageRoute(builder: (context) => PackagesPage()),
              //         );
              //       },
              //       child: Column(
              //         children: [
              //           Container(
              //             decoration: BoxDecoration(
              //               shape: BoxShape.circle,
              //               border: Border.all(
              //                 color: Colors.black,
              //               ),
              //               boxShadow: const [
              //                 BoxShadow(
              //                   color: Color.fromARGB(255, 0, 0, 0),
              //                 ),
              //                 BoxShadow(
              //                   color: Color.fromARGB(255, 255, 255, 255),
              //                   spreadRadius: 7.0,
              //                   blurRadius: 12.0,
              //                 ),
              //               ],
              //             ),
              //             child: Padding(
              //               padding: const EdgeInsets.all(10.0),
              //               child: Image.asset(
              //                 'images/widget/paket.png',
              //                 width: 50,
              //                 height: 50,
              //                 color: const Color.fromARGB(255, 0, 0, 0),
              //               ),
              //             ),
              //           ),
              //           const SizedBox(height: 5),
              //           const Text(
              //             'Paket',
              //             style: TextStyle(
              //               color: Color.fromARGB(255, 0, 0, 0),
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //     GestureDetector(
              //       onTap: () {
              //         Navigator.push(
              //           context,
              //           MaterialPageRoute(builder: (context) => TroublePage()),
              //         );
              //       },
              //       child: Column(
              //         children: [
              //           Container(
              //             decoration: BoxDecoration(
              //               shape: BoxShape.circle,
              //               border: Border.all(
              //                 color: Colors.black,
              //               ),
              //               boxShadow: const [
              //                 BoxShadow(
              //                   color: Color.fromARGB(255, 0, 0, 0),
              //                 ),
              //                 BoxShadow(
              //                   color: Color.fromARGB(255, 255, 255, 255),
              //                   spreadRadius: 7.0,
              //                   blurRadius: 12.0,
              //                 ),
              //               ],
              //             ),
              //             child: Padding(
              //               padding: const EdgeInsets.all(10.0),
              //               child: Image.asset(
              //                 'images/widget/gangguan.png',
              //                 width: 50,
              //                 height: 50,
              //                 color: const Color.fromARGB(255, 0, 0, 0),
              //               ),
              //             ),
              //           ),
              //           const SizedBox(height: 5),
              //           const Text(
              //             'Gangguan',
              //             style: TextStyle(
              //               color: Color.fromARGB(255, 0, 0, 0),
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //     GestureDetector(
              //       onTap: () {
              //         Navigator.push(
              //           context,
              //           MaterialPageRoute(builder: (context) => AllPage()),
              //         );
              //       },
              //       child: Column(
              //         children: [
              //           Container(
              //             decoration: BoxDecoration(
              //               shape: BoxShape.circle,
              //               border: Border.all(
              //                 color: Colors.black,
              //               ),
              //               boxShadow: const [
              //                 BoxShadow(
              //                   color: Color.fromARGB(255, 0, 0, 0),
              //                 ),
              //                 BoxShadow(
              //                   color: Color.fromARGB(255, 255, 255, 255),
              //                   spreadRadius: 7.0,
              //                   blurRadius: 12.0,
              //                 ),
              //               ],
              //             ),
              //             child: Padding(
              //               padding: const EdgeInsets.all(10.0),
              //               child: Image.asset(
              //                 'images/widget/semua.png',
              //                 width: 50,
              //                 height: 50,
              //                 color: const Color.fromARGB(255, 0, 0, 0),
              //               ),
              //             ),
              //           ),
              //           const SizedBox(height: 5),
              //           const Text(
              //             'Semua',
              //             style: TextStyle(
              //               color: Color.fromARGB(255, 0, 0, 0),
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ],
              // ),

              // New Card
              Container(
                margin: const EdgeInsets.only(bottom: 20.0),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MapSample(),
                      ),
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

              const SizedBox(height: 2),
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
                      GestureDetector(
                        onTap: () {
                          // Navigasi ke halaman yang diinginkan
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    PenawaranPage()), // Ganti dengan halaman yang diinginkan
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
