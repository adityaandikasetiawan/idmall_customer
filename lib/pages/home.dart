// ignore_for_file: empty_catches, avoid_print

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:idmall/pages/details.dart';
import 'package:idmall/pages/google_maps.dart';
import 'package:idmall/pages/invoice.dart';
import 'package:idmall/pages/invoice_testing.dart';
import 'package:idmall/service/coverage_area.dart';
import 'package:idmall/widget/widget_support.dart';
import 'package:idmall/widget/notificationpage.dart';
import 'package:idmall/pages/promo.dart';
import 'package:idmall/widget/penawaranterbaru.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:idmall/config/config.dart' as config;
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? name;
  String greeting = '';
  String points = '10';
  String vouchers = '1';
  String? package = "";
  String? basePackage = "";
  String? customerID = "";
  String? status = "";

  //endpoint h-7 billing
  String? billing = "";
  String? dueDate = "";
  bool isDueDateActive = false;

  final oCcy = NumberFormat("#,##0", "en_US");

  CarouselController controllerCarousel = CarouselController();
  int carouselIndex = 0;

  @override
  void initState() {
    super.initState();
    setGreeting();
    getUserName();
    dashboardData();
    billingData();
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
        "${config.backendBaseUrl}/customer/dashboard/detail-customer",
        options: Options(headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        }),
      );
      print(response.data);
      setState(() {
        package = response.data['data']['Package_Name'] ?? "";
        basePackage = response.data['data']['Base_Package_Name'] ?? "";
        customerID = response.data['data']['Task_ID'] ?? "";
        status = response.data['data']['Status'] ?? "";
      });
    } on DioException catch (e) {
      print(e.message);
      print(e.error);
    }
  }

  Future<void> billingData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String token = prefs.getString('token') ?? "";

      final response = await dio.get(
        "${config.backendBaseUrl}/customer/billing/due",
        options: Options(headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        }),
      );
      print(response.data['data'].length);

      if (response.data['data'].length > 0) {
        setState(
          () {
            isDueDateActive = true;
            billing = oCcy.format(response.data['data']['AR_Val']);
            DateTime dueDates =
                DateTime.tryParse(response.data['data']['Due_Date'])!;
            dueDate = DateFormat('MMMM, yyyy').format(dueDates);
            package = response.data['data']['Sub_Product'] ?? "";
            customerID = response.data['data']['Task_ID'] ?? "";
            status = response.data['data']['Status'] ?? "";
          },
        );
      }
    } on DioException catch (e) {
      print(e.message);
      print(e.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: const Image(
          image: AssetImage('images/background.png'),
          fit: BoxFit.cover,
        ),
        backgroundColor: Colors.transparent,
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
                        builder: (context) => const NotificationsPage(),
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
                          color: Colors.transparent,
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
                              builder: (context) => const NotificationsPage()),
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
                          color: Colors.transparent,
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
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            margin: const EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //new detail customer
                const Text(
                  "Paket Anda",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 10,
                    color: Colors.black,
                  ),
                ),
                GlassContainer(
                  width: double.infinity * 2,
                  blur: 4,
                  color: Colors.white.withOpacity(0.5),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(0.4),
                      Colors.white.withOpacity(0.35),
                    ],
                  ),
                  border: const Border.fromBorderSide(BorderSide.none),
                  shadowStrength: 4,
                  borderRadius: BorderRadius.circular(16),
                  shadowColor: Colors.black.withOpacity(0.43),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "$customerID",
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontFamily: "Roboto Flex",
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: const Color.fromARGB(255, 254, 114, 76),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  "$package",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 7,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 50,
                              width: 20,
                              child: VerticalDivider(
                                width: 5,
                                thickness: 3,
                                indent: 5,
                                endIndent: 5,
                                color: Color.fromARGB(255, 255, 255, 255),
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  "$basePackage",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const Text(
                                  "130GB",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Image.asset(
                                      "images/icon_globe.png",
                                      width: 10,
                                      height: 10,
                                    ),
                                    const SizedBox(
                                      width: 3,
                                    ),
                                    Text(
                                      "Penggunaan Dalam Sebulan",
                                      style: TextStyle(
                                        fontSize: 6,
                                        color: Colors.grey[600],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Divider(
                          thickness: 3,
                          indent: 30,
                          endIndent: 30,
                          color: Colors.white,
                        ),
                        const Text(
                          "Riwayat Transaksi",
                          style: TextStyle(
                            color: Colors.orange,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Billing Payment",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 10,
                    color: Colors.black,
                  ),
                ),
                GlassContainer(
                  width: double.infinity * 2,
                  blur: 4,
                  color: Colors.white.withOpacity(0.5),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(0.4),
                      Colors.white.withOpacity(0.35),
                    ],
                  ),
                  border: const Border.fromBorderSide(BorderSide.none),
                  shadowStrength: 4,
                  borderRadius: BorderRadius.circular(16),
                  shadowColor: Colors.black.withOpacity(0.43),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Icon(
                          Icons.wifi,
                          color: Color.fromARGB(255, 254, 114, 76),
                          size: 30,
                        ),
                        Column(
                          children: [
                            const Text(
                              "Actual Bill Periode",
                              style: TextStyle(
                                color: Color.fromARGB(255, 83, 83, 83),
                                fontWeight: FontWeight.w500,
                                fontFamily: "Roboto",
                              ),
                            ),
                            Text(
                              "$dueDate",
                              style: const TextStyle(
                                color: Color.fromARGB(255, 83, 83, 83),
                                fontWeight: FontWeight.w500,
                                fontFamily: "Robotto",
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "Rp. $billing",
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Robotto",
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: const LinearGradient(
                          colors: [
                            Color.fromARGB(255, 155, 156, 248),
                            Color.fromARGB(255, 128, 130, 237),
                          ],
                        ),
                      ),
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                          ),
                          child: const Icon(
                            Icons.arrow_upward,
                            color: Color.fromARGB(255, 128, 130, 237),
                          ),
                        ),
                        label: const Text("Upgrade"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: const LinearGradient(
                          colors: [
                            Color.fromARGB(255, 254, 180, 197),
                            Color.fromARGB(255, 219, 134, 154),
                          ],
                        ),
                      ),
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                          ),
                          child: const Icon(
                            Icons.arrow_downward,
                            color: Color.fromARGB(255, 238, 159, 177),
                          ),
                        ),
                        label: const Text("Downgrade"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                //new check coverage
                GlassContainer(
                  width: double.infinity * 2,
                  blur: 4,
                  color: Colors.white.withOpacity(0.5),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(0.4),
                      Colors.white.withOpacity(0.35),
                    ],
                  ),
                  border: const Border.fromBorderSide(BorderSide.none),
                  shadowStrength: 4,
                  borderRadius: BorderRadius.circular(16),
                  shadowColor: Colors.black.withOpacity(0.43),
                  child: Stack(
                    children: [
                      const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                        child: Column(
                          children: [
                            Text(
                              "Cek",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 22,
                                fontFamily: "Plus Jakarta Sans",
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              "Lokasi Anda disini",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 22,
                                fontFamily: "Plus Jakarta Sans",
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        right: 53,
                        child: Image.asset(
                          "images/idmall_logo.png",
                          height: 70,
                          width: 70,
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                      Positioned(
                        right: 0,
                        top: 8,
                        child: ClipRect(
                          clipBehavior: Clip.hardEdge,
                          child: Image.asset(
                            "images/coverage.png",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                // new play product list for home
                CarouselSlider(
                  carouselController: controllerCarousel,
                  options: CarouselOptions(
                    height: 400.0,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 3),
                    autoPlayAnimationDuration:
                        const Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeFactor: 0.3,
                    scrollDirection: Axis.horizontal,
                  ),
                  items: [1, 2, 3, 4, 5].map((i) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Stack(
                          fit: StackFit.loose,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width / 1.6,
                              decoration: const BoxDecoration(
                                  color: Colors.transparent),
                              child: GlassContainer(
                                height: 400,
                                blur: 4,
                                color: Colors.white.withOpacity(0.5),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.white.withOpacity(0.4),
                                    Colors.white.withOpacity(0.35),
                                  ],
                                ),
                                border: const Border.fromBorderSide(
                                    BorderSide.none),
                                shadowStrength: 4,
                                borderRadius: BorderRadius.circular(16),
                                shadowColor: Colors.black.withOpacity(0.43),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 0,
                                    horizontal: 30,
                                  ),
                                  child: const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.speed,
                                            size: 25,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            'Internet Tanpa Batas 30 MB',
                                            style: TextStyle(fontSize: 12.0),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.router,
                                            size: 25,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            'Gratis Router Wi-Fi',
                                            style: TextStyle(fontSize: 12.0),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.settings,
                                            size: 25,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            'Gratis Instalasi',
                                            style: TextStyle(fontSize: 12.0),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.device_hub,
                                            size: 25,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            'Ideal untuk 8 - 12 devices',
                                            style: TextStyle(fontSize: 12.0),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.wifi_sharp,
                                            size: 25,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Text(
                                              'Ideal untuk keluarga dengan pemakaian standar',
                                              style: TextStyle(fontSize: 10.0),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: ClipRect(
                                clipBehavior: Clip.hardEdge,
                                child: Image.asset(
                                  "images/carousel_bg.png",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(
                  height: 20,
                ),
                // new play product list for home
                Column(
                  children: [
                    CarouselSlider(
                      options: CarouselOptions(
                        height: 400.0,
                        autoPlay: true,
                        autoPlayInterval: const Duration(seconds: 3),
                        autoPlayAnimationDuration:
                            const Duration(milliseconds: 800),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enlargeFactor: 0.3,
                        scrollDirection: Axis.horizontal,
                        onPageChanged: (index, reason) {
                          setState(() {
                            carouselIndex = index;
                          });
                        },
                      ),
                      items: [1, 2, 3, 4, 5].map((i) {
                        return Builder(
                          builder: (BuildContext context) {
                            return SizedBox(
                              width: MediaQuery.of(context).size.width / 1.6,
                              // decoration: const BoxDecoration(
                              //     color: Colors.transparent),
                              child: GlassContainer(
                                height: 400,
                                blur: 4,
                                color: Colors.white.withOpacity(0.5),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.white.withOpacity(0.4),
                                    Colors.white.withOpacity(0.35),
                                  ],
                                ),
                                border: const Border.fromBorderSide(
                                    BorderSide.none),
                                shadowStrength: 4,
                                borderRadius: BorderRadius.circular(16),
                                shadowColor: Colors.black.withOpacity(0.43),
                                child: Stack(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 20,
                                        horizontal: 30,
                                      ),
                                      child: const Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.speed,
                                                size: 25,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                'Internet Tanpa Batas 30 MB',
                                                style:
                                                    TextStyle(fontSize: 12.0),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.router,
                                                size: 25,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                'Gratis Router Wi-Fi',
                                                style:
                                                    TextStyle(fontSize: 12.0),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.settings,
                                                size: 25,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                'Gratis Instalasi',
                                                style:
                                                    TextStyle(fontSize: 12.0),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.device_hub,
                                                size: 25,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                'Ideal untuk 8 - 12 devices',
                                                style:
                                                    TextStyle(fontSize: 12.0),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.wifi_sharp,
                                                size: 25,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  'Ideal untuk keluarga dengan pemakaian standar',
                                                  style:
                                                      TextStyle(fontSize: 10.0),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 25,
                                          ),
                                          Expanded(
                                            child: Text(
                                              "Rp. 900.000 / bulan",
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                color: Colors.orange,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      right: 0,
                                      bottom: 0,
                                      child: ClipRect(
                                        clipBehavior: Clip.hardEdge,
                                        child: Image.asset(
                                          "images/carousel_bg.png",
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }).toList(),
                    ),
                    DotsIndicator(
                      dotsCount: 5,
                      position: carouselIndex.toDouble(),
                      decorator: DotsDecorator(
                        shape: const Border(),
                        size: const Size.square(9.0),
                        activeSize: const Size(18.0, 9.0),
                        activeShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                      ),
                    )
                  ],
                ),
                // New Promotion Cards
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
                                builder: (context) => const PenawaranPage(),
                              ),
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
                    const SizedBox(height: 5),
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

  const CardWidgetWithIcon({
    super.key,
    required this.icon,
    required this.text,
    required this.value,
  });

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
