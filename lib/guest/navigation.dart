import 'package:flutter/cupertino.dart';
import 'package:idmall/guest/dashboard.dart';
import 'package:idmall/pages/kategori.dart';
import 'package:idmall/pages/pelaporan.dart';
import 'package:idmall/pages/account.dart';
import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';

class NavigationGuest extends StatefulWidget {
  const NavigationGuest({super.key});

  @override
  State<NavigationGuest> createState() => _NavigationGuestState();
}

class _NavigationGuestState extends State<NavigationGuest> {
  int pageIndex = 0;

  List<Widget> pages = [
    const DashboardGuest(),
    const CategoryPage(),
    const PelaporanPage(),
    const Account(),
  ];
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
                showModalBottomSheet<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                      height:
                          100, // Sesuaikan tinggi bottom sheet sesuai kebutuhan
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: <Widget>[
                          IconButton(
                            onPressed: () {
                              // Aksi yang diinginkan saat ikon pertama ditekan
                            },
                            icon: const Icon(Icons.favorite),
                            color: Colors.red,
                            iconSize: 40,
                          ),
                          IconButton(
                            onPressed: () {
                              // Aksi yang diinginkan saat ikon kedua ditekan
                            },
                            icon: const Icon(Icons.star),
                            color: Colors.yellow,
                            iconSize: 40,
                          ),
                          IconButton(
                            onPressed: () {
                              // Aksi yang diinginkan saat ikon ketiga ditekan
                            },
                            icon: const Icon(Icons.share),
                            color: Colors.blue,
                            iconSize: 40,
                          ),
                          // Lanjutkan menambahkan ikon-ikon lainnya sesuai kebutuhan
                        ],
                      ),
                    );
                  },
                );
              },
              icon: Image.asset(
                'images/splash.png', // Ubah 'your_image.png' sesuai dengan nama dan lokasi gambar Anda
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
          CupertinoIcons.compass,
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
