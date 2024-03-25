import 'package:flutter/cupertino.dart';
import 'package:idmall/pages/broadbandbisnis.dart';
import 'package:idmall/pages/broadbandhome.dart';
import 'package:idmall/pages/enterprisesolution.dart';
import 'package:idmall/pages/helpcenter.dart';
import 'package:idmall/pages/history.dart';
import 'package:idmall/pages/home.dart';
import 'package:idmall/pages/kategori.dart';
import 'package:idmall/pages/pelaporan.dart';
import 'package:idmall/pages/account.dart';
import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int pageIndex = 0;

  List<Widget> pages = [
    const Home(),
    const HistoryList(),
    const HelpCenterPage(),
    // const PelaporanPage(),
    const Account(),
  ];
  Future<void> logout() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    _pref.remove('token');
    _pref.remove('fullName');
    _pref.remove('user_id');
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
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
