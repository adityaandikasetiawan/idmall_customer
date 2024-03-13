import 'package:idmall/pages/wallet.dart';
import 'package:idmall/pages/home.dart';
import 'package:idmall/pages/order.dart';
import 'package:idmall/pages/profile.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({Key? key}) : super(key: key);

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int currentTabIndex = 0;

  late List<Widget> pages;
  late Home homepage;
  late Order order;
  late Wallet wallet;
  late Profile profile;

  @override
  void initState() {
    homepage = const Home();
    order = const Order();
    wallet = const Wallet();
    profile = const Profile();
    pages = [homepage, order, wallet, profile];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        height: 55,
        backgroundColor: Color.fromARGB(255, 226, 226, 226),
        color: const Color.fromARGB(255, 228, 99, 7),
        animationDuration: const Duration(milliseconds: 500),
        onTap: (int index) {
          setState(() {
            currentTabIndex = index;
          });
        },
        items: [
          const Icon(Icons.home, color: Colors.white),
          Image.asset(
            'images/Stoke.png', // Ubah 'your_image.png' sesuai dengan nama dan lokasi gambar Anda
            height: 24, // Sesuaikan dengan tinggi yang diinginkan
            width: 24, // Sesuaikan dengan lebar yang diinginkan
          ),
          Icon(Icons.headset_mic, color: Colors.white),
          Icon(Icons.person, color: Colors.white),
        ],
      ),
      body: pages[currentTabIndex],
    );
  }
}
