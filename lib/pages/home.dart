import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:idmall/pages/details.dart';
import 'package:idmall/service/database.dart';
import 'package:idmall/service/shared_preference_helper.dart';
import 'package:idmall/widget/button.dart';
import 'package:idmall/widget/widget_support.dart';

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
    ontheload();
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

  bool cake = false, food = false, drink = false;

  Stream? fooditemStream;

  ontheload() async {
    await getthesharedpref();
    fooditemStream = await DatabaseMethods().getFoodItem("Cake");
    setState(() {});
  }

  Widget allItemsVertically() {
    return StreamBuilder(
      stream: fooditemStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData && snapshot.data.docs.isNotEmpty) {
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: List.generate(snapshot.data.docs.length, (index) {
                DocumentSnapshot ds = snapshot.data.docs[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Details(
                          detail: ds["Detail"],
                          name: ds["Name"],
                          price: ds["Price"],
                          image: ds["Image"],
                        ),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      ClipPath(
                        clipper: ShapeBezierRightToLeft(),
                        child: Card(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          elevation: 4.0,
                          child: Padding(
                            padding: const EdgeInsets.all(30.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Image.network(
                                    ds["Image"],
                                    height: 100,
                                    width: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 20.0),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        ds["Name"],
                                        style:
                                            AppWidget.semibold2TextFeildStyle(),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 5.0),
                                      Text(
                                        ds["Detail"],
                                        style: AppWidget.Light2TextFeildStyle(),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 5.0),
                                      Text(
                                        "Rp." + ds["Price"],
                                        style:
                                            AppWidget.semibold2TextFeildStyle(),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      ClipPath(
                        clipper: ShapeBezierLeftToRight(),
                        child: Container(
                          color: Colors.transparent,
                          height: 20,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget allItems() {
    return StreamBuilder(
        stream: fooditemStream,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: snapshot.data.docs.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Details(
                                    detail: ds["Detail"],
                                    name: ds["Name"],
                                    price: ds["Price"],
                                    image: ds["Image"],
                                  )));
                    },
                    child: SingleChildScrollView(
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        child: Material(
                          elevation: 5.0,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.network(
                                    ds["Image"],
                                    height: 150,
                                    width: 160,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5.0,
                                ),
                                Text(
                                  ds["Name"].length > 10
                                      ? ds["Name"].substring(0, 10) + '...'
                                      : ds["Name"],
                                  style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontFamily: 'Poppins'),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.justify,
                                ),
                                const SizedBox(
                                  height: 5.0,
                                ),
                                Text(
                                  ds["Detail"],
                                  style: AppWidget.Light2TextFeildStyle(),
                                ),
                                const SizedBox(
                                  height: 5.0,
                                ),
                                Text(
                                  "Rp. " + ds["Price"],
                                  style: AppWidget.semibold2TextFeildStyle(),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                });
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff343456),
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
                          style: AppWidget.boldTextFeildStyle(),
                        ),
                        TextSpan(
                          text: "${name ?? "Guest"}",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white, // Ubah warna sesuai kebutuhan
                            fontFamily:
                                'Poppins', // Sesuaikan dengan gaya font yang Anda gunakan
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.notifications),
                          color: Colors.white,
                          onPressed: () {
                            // Aksi ketika notifikasi diklik
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.chat_bubble),
                          color: Colors.white,
                          onPressed: () {
                            // Aksi ketika chatbot diklik
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.shopping_cart),
                          color: Colors.white,
                          onPressed: () {
                            // Aksi ketika troli diklik
                          },
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
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CardWidgetWithIcon(
                          icon: Icons.point_of_sale,
                          text: 'Poin',
                          value: points,
                        ),
                        SizedBox(
                            width:
                                20), // Tambahkan jarak horizontal di antara widget
                        CardWidgetWithIcon(
                          icon: Icons.receipt,
                          text: 'Aktual Billing',
                          value: billing,
                        ),
                        SizedBox(
                            width:
                                20), // Tambahkan jarak horizontal di antara widget
                        CardWidgetWithIcon(
                          icon: Icons.card_giftcard,
                          text: 'Voucher',
                          value: vouchers,
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
                                ),
                              ),
                              SizedBox(height: 10.0),
                              Text(
                                'Learn More',
                                style: TextStyle(
                                  fontSize: 12.0,
                                  color: Color.fromARGB(255, 228, 99,
                                      7), // Ubah warna sesuai kebutuhan
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Image.asset(
                            'images/card2.png', // Ganti dengan path gambar yang sesuai
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
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
                      // Tindakan ketika ikon "Paket" diklik
                    },
                    child: Column(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.black,
                          radius: 30,
                          child: Icon(
                            Icons.shop,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Paket',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Tindakan ketika ikon "Gangguan" diklik
                    },
                    child: Column(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.black,
                          radius: 30,
                          child: Icon(
                            Icons.warning,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Gangguan',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Tindakan ketika ikon "Semua" diklik
                    },
                    child: Column(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.black,
                          radius: 30,
                          child: Icon(
                            Icons.all_inclusive,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Semua',
                          style: TextStyle(color: Colors.white),
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

              SizedBox(height: 20),
              // Carousel slides
              Container(
                height: 250,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    buildCarouselItem(
                      title: 'Title 1',
                      price: 'Rp. 100.000',
                      imagePath: 'images/promo1.png',
                      backgroundColor: Color.fromARGB(255, 26, 27, 76), // Change background color as needed
                    ),
                    buildCarouselItem(
                      title: 'Title 2',
                      price: 'Rp. 150.000',
                      imagePath: 'images/promo2.png',
                      backgroundColor: const Color.fromARGB(255, 26, 27, 76), // Change background color as needed
                    ),
                    buildCarouselItem(
                      title: 'Title 3',
                      price: 'Rp. 200.000',
                      imagePath: 'images/promo3.png',
                      backgroundColor: const Color.fromARGB(255, 26, 27, 76), // Change background color as needed
                    ),
                  ],
                ),
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
