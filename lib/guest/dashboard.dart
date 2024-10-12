import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:idmall/controller/dashboard.controller.dart';
import 'package:idmall/models/product_flyer.dart';
import 'package:idmall/pages/details_product.dart';
import 'package:idmall/pages/google_maps.dart';
import 'package:idmall/pages/login.dart';
import 'package:idmall/widget/widget_support.dart';
import 'package:idmall/pages/promo.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class DashboardGuest extends StatefulWidget {
  const DashboardGuest({super.key});

  @override
  State<DashboardGuest> createState() => _DashboardGuestState();
}

class _DashboardGuestState extends State<DashboardGuest> {
  final DashboardController dashboardController =
      Get.put(DashboardController());

  String? name;
  String greeting = '';
  String points = '10';
  String billing = 'Rp 179.000';
  String vouchers = '1';
  bool isAllowed = false;

  @override
  void initState() {
    super.initState();
    setGreeting();
    dashboardController.productBisnis();
    dashboardController.productHome();
  }

  Future<void> fetchRefreshData() async {
    await dashboardController.fetchProductBisnis();
    await dashboardController.fetchProductHome();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 250, 255),
      body: RefreshIndicator(
        onRefresh: fetchRefreshData,
        child: SingleChildScrollView(
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
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: name ?? "Guest",
                            style: const TextStyle(
                              fontSize: 18,
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontFamily: 'Poppins',
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
                                builder: (context) => const Login(),
                              ),
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
                          MaterialPageRoute(
                            builder: (context) => PromoPage(),
                          ),
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
                      if (!isAllowed) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Penggunaan Lokasi"),
                              content: const Text(
                                "Idmall mengumpulkan data terkait lokasi pengguna untuk mengidentifikasi ketersediaan layanan kami dengan lokasi pengguna",
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("Tolak"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const MapSample(),
                                      ),
                                    );
                                    isAllowed = true;
                                  },
                                  child: const Text("Terima"),
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MapSample(),
                          ),
                        );
                      }
                    },
                    child: Card(
                      elevation: 4.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      color: const Color.fromARGB(255, 19, 24, 84),
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
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Image.asset(
                                'images/coverange.png',
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
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Penawaran Terbaru',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                  ],
                ),

                const SizedBox(height: 20),

                Obx(
                  () {
                    if (dashboardController.isLoading.value) {
                      return Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 100.0,
                          color: Colors.grey[300],
                        ),
                      );
                    } else {
                      return Card(
                        color: Color.fromARGB(
                          1,
                          217,
                          217,
                          217,
                        ).withOpacity(0.2),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "IDPLAY HOME",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                  fontFamily: "Inter",
                                ),
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount:
                                    dashboardController.productHome.length,
                                itemBuilder: (context, index) {
                                  ProductFlyer productHome =
                                      dashboardController.productHome[index];
                                  return InternetSpeedCard(
                                    id: productHome.id.toString(),
                                    speed: productHome.speed,
                                    price: productHome.price,
                                    packageName: productHome.name,
                                  );
                                },
                              ),
                              SizedBox(
                                height: 8,
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  },
                ),

                SizedBox(
                  height: 20,
                ),

                Obx(
                  () {
                    if (dashboardController.isLoading.value) {
                      return Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 100.0,
                          color: Colors.grey[300],
                        ),
                      );
                    } else {
                      return Card(
                        color: Color.fromARGB(
                          1,
                          217,
                          217,
                          217,
                        ).withOpacity(0.2),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "IDPLAY BISNIS",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                  fontFamily: "Inter",
                                ),
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount:
                                    dashboardController.productBisnis.length,
                                itemBuilder: (context, index) {
                                  ProductFlyer productBisnis =
                                      dashboardController.productBisnis[index];
                                  return InternetSpeedCard(
                                    id: productBisnis.id.toString(),
                                    speed: productBisnis.speed,
                                    price: productBisnis.price,
                                    packageName: productBisnis.name,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  },
                ),
                // SizedBox(
                //   height: 300,
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class InternetSpeedCard extends StatelessWidget {
  final String id;
  final int speed;
  final int price;
  final String packageName;

  const InternetSpeedCard({
    super.key,
    required this.id,
    required this.speed,
    required this.price,
    required this.packageName,
  });

  @override
  Widget build(BuildContext context) {
    final oCcy = NumberFormat("#,##0", "en_US");

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('$speed Mbps', style: TextStyle(color: Colors.red)),
                  Text(
                    "Rp. ${oCcy.format(price).replaceAll(",", ".")}",
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(packageName),
                  SizedBox(width: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    onPressed: () {
                      Get.to(
                        () => DetailPage(
                          ids: id,
                          isGuest: 1,
                        ),
                      );
                    },
                    child: Text(
                      'Beli',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
