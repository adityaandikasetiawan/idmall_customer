import 'package:idmall/pages/wallet.dart';
import 'package:idmall/pages/home.dart';
import 'package:idmall/pages/order.dart';
import 'package:idmall/pages/profile.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int currentTabIndex=0;

  late List<Widget> pages;
  late Widget currentPage;
  late Home homepage;
  late Order order;
  late Wallet wallet;
  late Profile profile;

  @override
  void initState() {
    homepage=const Home();
    order=const Order();
    wallet=const Wallet();
    profile=const Profile();
    pages=[homepage,order, wallet, profile];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
          height: 55,
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
          color: Color.fromARGB(255, 228, 99, 7),
          animationDuration: const Duration(milliseconds: 500),
          onTap: (int index){
            setState(() {
              currentTabIndex=index;
            });
          },
          items: const [
        Icon(
        Icons.home_outlined,
        color: Colors.white,),
        Icon(Icons.compass_calibration,
        color: Colors.white,),
        Icon(Icons.headphones,
        color: Colors.white,),
        Icon(Icons.person_outlined,
        color: Colors.white,),
      ]),
      body: pages[currentTabIndex],
    );
  }
}
