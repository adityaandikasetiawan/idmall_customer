// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:idmall/pages/bantuan/bantuan.dart';
import 'package:idmall/pages/history.dart';
import 'package:idmall/pages/home.dart';
import 'package:idmall/pages/account.dart';
import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:idmall/pages/new_home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:idmall/config/config.dart' as config;

class NavigationScreen extends StatefulWidget {
  final String? customerID;
  final String? status;
  const NavigationScreen({
    super.key,
    this.customerID,
    this.status,
  });

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int pageIndex = 0;
  String? _customerid, _status;
  late List<Widget> pages = [];

  @override
  void initState() {
    super.initState();
    getDetailCustomer().then((_) {
      setState(() {
        pages = [
          const NewHomeScreen(),
          HistoryList(
            customerId: _customerid,
            status: _status,
          ),
          const Bantuan(),
          const Account(),
        ];
      });
    });
  }

  Future<void> getDetailCustomer() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String token = prefs.getString('token') ?? "";
      final dio = Dio();
      final response = await dio.get(
        "${config.backendBaseUrl}/customer/dashboard/detail-customer",
        options: Options(headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
          "Cache-Control": "no-cache"
        }),
      );
      if (response.data['data'].length > 0) {
        await prefs.setString(
            "token", response.data['data']['Updated_Auth_Token']);
        setState(
          () {
            _customerid = response.data['data']['Task_ID'];
            _status = response.data['data']['Status'];
          },
        );
      }
    } on DioException catch (e) {
      print(e.error);
      print(e.message);
    }
  }

  Future<void> logout() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove('token');
    pref.remove('fullName');
    pref.remove('user_id');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: pageIndex,
        children: pages,
      ),
      floatingActionButton: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.transparent,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color.fromARGB(255, 0, 0, 0),
              ),
              BoxShadow(
                color: Color.fromARGB(255, 255, 255, 255),
                spreadRadius: 4.0,
              ),
            ],
          ),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color.fromARGB(255, 255, 255, 255),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2), // Warna shadow
                  spreadRadius: 2, // Besar penyebaran shadow
                  blurRadius: 5, // Besar blur shadow
                  offset: const Offset(0, 3), // Pergeseran shadow
                ),
              ],
            ),
            padding: const EdgeInsets.all(
                8), // Sesuaikan ukuran padding inner circle sesuai kebutuhan
            child: IconButton(
              onPressed: () {
                print("clicked home button");
                // Navigator.pushReplacement<void, void>(
                //   context,
                //   MaterialPageRoute<void>(
                //     builder: (BuildContext context) => const Home(),
                //   ),
                // );
              },
              icon: Image.asset(
                'images/idmall_logo.png', // Ubah 'your_image.png' sesuai dengan nama dan lokasi gambar Anda
                height: 60,
                width: 60,
              ),
              padding: EdgeInsets.zero, // Hilangkan padding dari IconButton
              splashRadius: 30, // Ukuran radius efek splash saat tombol ditekan
              color: Colors.white, // Warna ikon
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: const [
          CupertinoIcons.house_fill,
          Icons.history,
          CupertinoIcons.headphones,
          CupertinoIcons.profile_circled,
        ],
        // splashColor
        inactiveColor: Colors.grey.withOpacity(0.5),
        activeColor: Colors.orange,
        gapLocation: GapLocation.center,
        activeIndex: pageIndex,
        notchSmoothness: NotchSmoothness.softEdge,
        leftCornerRadius: 10,
        iconSize: 25,
        rightCornerRadius: 10,
        elevation: 0,
        onTap: (index) {
          setState(() {
            pageIndex = index;
          });
        },
      ),
    );
  }
}
