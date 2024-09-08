// ignore_for_file: empty_catches, avoid_print, use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:idmall/models/customer_by_email.dart';
import 'package:idmall/pages/details.dart';
import 'package:idmall/pages/fab_testing.dart';
import 'package:idmall/pages/google_maps.dart';
import 'package:idmall/pages/pembayaran_existing.dart';
import 'package:idmall/pages/pembayaran_testing.dart';
import 'package:idmall/pages/upgrade_downgrade_detail.dart';
import 'package:idmall/service/coverage_area.dart';
import 'package:idmall/widget/widget_support.dart';
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
  String? fullName;
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
  List<CustomerListByEmail> customerListEmails = [];

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
    String? fullNames = prefs.getString("fullName");
    List<String> nameParts = fullNames!.split(" ");

    setState(() {
      name = nameParts[0];
      fullName = fullNames;
    });
  }

  Future<void> dashboardData() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      final String token = prefs.getString('token') ?? "";

      final response = await dio.get(
        "${config.backendBaseUrl}/customer/dashboard/detail-customer",
        options: Options(headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
          "Cache-Control": "no-cache"
        }),
      );

      final response2 = await dio.get(
        "${config.backendBaseUrl}/customer/billing/due",
        options: Options(headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
          "Cache-Control": "no-cache"
        }),
      );

      final response3 = await dio.get(
        "${config.backendBaseUrl}/customer/billing/list",
        options: Options(headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
          "Cache-Control": "no-cache"
        }),
      );

      for (var ele in response3.data['data']) {
        customerListEmails.add(CustomerListByEmail.fromJson(ele));
      }

      if (response.data['data'].length > 0) {
        await prefs.setString(
            "token", response.data['data']['Updated_Auth_Token']);
        setState(
          () {
            package = response.data['data']['Package_Name'] ?? "";
            basePackage = response.data['data']['Base_Package_Name'] ?? "";
            customerID = response.data['data']['Task_ID'] ?? "";
            status = response.data['data']['Status'] ?? "";
          },
        );
      }

      if (response2.data['data'].length > 0) {
        setState(
          () {
            isDueDateActive = true;
            billing = oCcy.format(response.data['data']['AR_Val']);
            DateTime dueDates =
                DateTime.tryParse(response.data['data']['Due_Date'])!;
            dueDate = DateFormat('MMMM, yyyy').format(dueDates);
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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                showModalBottomSheet<void>(
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(15.0),
                    ),
                  ),
                  useSafeArea: true,
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                      padding: const EdgeInsets.all(15),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 2,
                      child: ListView(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "PROFIL ANDA",
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 15),
                          Expanded(
                            child: ListTile(
                              onTap: () {
                                // Tindakan saat bagian pertama ditekan
                              },
                              leading: const Icon(Icons.account_circle),
                              title: Text("$fullName"),
                              subtitle: Text("$status - $basePackage"),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            "Nomor pelanggan yang Anda kelola",
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          ListTile(
                            onTap: () {
                              // Tindakan saat bagian pertama ditekan
                            },
                            leading: const Icon(Icons.home),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("$customerID"),
                                const Row(
                                  children: [
                                    Text(
                                      "Aktif",
                                      style: TextStyle(color: Colors.orange),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: 15,
                                      color: Colors.orange,
                                    )
                                  ],
                                )
                              ],
                            ),
                            subtitle: Text("$fullName"),
                          ),
                          const Divider(),
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 4,
                            child: ListView.builder(
                              itemCount: customerListEmails.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  onTap: () async {
                                    final prefs =
                                        await SharedPreferences.getInstance();
                                    String token =
                                        prefs.getString('token') ?? "";

                                    final response = await dio.get(
                                      "${config.backendBaseUrl}/billing/get",
                                      options: Options(headers: {
                                        "Content-Type": "application/json",
                                        "Authorization": "Bearer $token",
                                        "Cache-Control": "no-cache"
                                      }),
                                      data: {
                                        "task_id":
                                            customerListEmails[index].customerId
                                      },
                                    );
                                    if (response.data['data'].length > 0) {
                                      await prefs.setString(
                                        "token",
                                        response.data['data'][0]
                                            ['Updated_Auth_Token'],
                                      );
                                      setState(
                                        () {
                                          package = response.data['data'][0]
                                                  ['Package_Name'] ??
                                              "";
                                          basePackage = response.data['data'][0]
                                                  ['Base_Package_Name'] ??
                                              "";
                                          customerID = response.data['data'][0]
                                                  ['Task_ID'] ??
                                              "";
                                          status = response.data['data'][0]
                                                  ['Status'] ??
                                              "";
                                          // isDueDateActive = true;
                                          // billing = oCcy.format(response
                                          //     .data['data'][0]['AR_Val']);
                                          // DateTime dueDates = DateTime.tryParse(
                                          //     response.data['data'][0]
                                          //         ['Due_Date'])!;
                                          // dueDate = DateFormat('MMMM, yyyy')
                                          //     .format(dueDates);
                                        },
                                      );
                                    }
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text("Success"),
                                          content: Text(
                                              "Berhasil pindah ke CID ${customerListEmails[index].customerId}"),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).popUntil(
                                                    (route) => route.isFirst);
                                              },
                                              child: const Text("OK"),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  leading: const Icon(Icons.home),
                                  title: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          customerListEmails[index].customerId),
                                    ],
                                  ),
                                  subtitle: Text(
                                      "${customerListEmails[index].name} - ${customerListEmails[index].status}"),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              child: Row(
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
                              255,
                              0,
                              0,
                              0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
            // Row(
            //   children: [
            //     GestureDetector(
            //       onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //       builder: (context) => const NotificationPage()),
                    // );
            //       },
            //       child: Container(
            //         decoration: BoxDecoration(
            //           borderRadius: BorderRadius.circular(15),
            //           border: Border.all(
            //             color: Colors.black,
            //           ),
            //           boxShadow: const [
            //             BoxShadow(
            //               color: Color.fromARGB(255, 0, 0, 0),
            //             ),
            //             BoxShadow(
            //               color: Color.fromARGB(255, 255, 255, 255),
            //               spreadRadius: 7.0,
            //               blurRadius: 12.0,
            //             ),
            //           ],
            //         ),
                    // child: IconButton(
                    //   icon: const Icon(Icons.notifications),
                    //   color: const Color.fromARGB(255, 0, 0, 0),
                    //   onPressed: () {
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //           builder: (context) => const NotificationPage()),
                    //     );
                    //   },
                    // ),
            //       ),
            //     ),
            //     const SizedBox(width: 10),
            //     GestureDetector(
            //       onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => InvoicePage(
                    //           taskid: customerID ?? "",
                    //           bankName: "",
                    //           total: "",
                    //           typePayment: "",
                    //         ),
                    //   ),
                    // );
            //       },
            //       child: Container(
            //         decoration: BoxDecoration(
            //           borderRadius: BorderRadius.circular(15),
            //           border: Border.all(
            //             color: Colors.black,
            //           ),
            //           boxShadow: const [
            //             BoxShadow(
            //               color: Color.fromARGB(255, 0, 0, 0),
            //             ),
            //             BoxShadow(
            //               color: Color.fromARGB(255, 255, 255, 255),
            //               spreadRadius: 7.0,
            //               blurRadius: 12.0,
            //             ),
            //           ],
            //         ),
                    // child: IconButton(
                    //   icon: const Icon(Icons.shopping_cart),
                    //   color: const Color.fromARGB(255, 0, 0, 0),
                    //   onPressed: () {
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //         builder: (context) => InvoicePage(
                    //           taskid: customerID ?? "",
                    //           bankName: "",
                    //           total: "",
                    //           typePayment: "",
                    //         ),
                    //       ),
                    //     );
                    //   },
                    // ),
            //       ),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 250, 250, 255),
      body: RefreshIndicator(
        onRefresh: dashboardData,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            margin: const EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //card menuju FAB & pending payment
                status == "QUOTATION" || status == "PENDING_PAYMENT_MOBILE"
                    ? GestureDetector(
                        onTap: () {
                          if (status == "QUOATATION") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    FABTesting(taskID: customerID ?? ""),
                              ),
                            );
                          } else if (status == "PENDING_PAYMENT_MOBILE" ||
                              status == "PENDING_PAYMENT") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PaymentMethod(
                                  taskid: customerID ?? "",
                                ),
                              ),
                            );
                          }
                        },
                        child: SizedBox(
                          width: double.infinity * 2,
                          child: Card(
                            elevation: 4.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    15), // Bentuk sudut container
                                image: const DecorationImage(
                                  image: AssetImage(
                                      'images/bb_green_mint.jpg'), // Gambar background
                                  fit: BoxFit
                                      .cover, // Menyesuaikan gambar dengan ukuran container
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    status == "QUOTATION"
                                        ? const Text(
                                            "Registrasi Anda sudah disetujui, mohon isi FORM AKTIVASI BERLANGGANAN",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        : const Text(
                                            "Registrasi Anda mencapai tahap pembayaran, silahkan melanjutkan ke proses pembayaran",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    : const SizedBox(),

                //card billing, point, etc
                status == "ACTIVE" || status == "DU" || status == "FREEZE"
                    ? SizedBox(
                        key: UniqueKey(),
                        width: double.infinity * 2,
                        child: Card(
                          elevation: 4.0,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(15), // Bentuk sudut card
                          ),
                          // Mengubah warna background menjadi biru dongker
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  15), // Bentuk sudut container
                              image: const DecorationImage(
                                image: AssetImage(
                                    'images/bb_green_mint.jpg'), // Gambar background
                                fit: BoxFit
                                    .cover, // Menyesuaikan gambar dengan ukuran container
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "$customerID",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "$package",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "$status",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    : const SizedBox(),

                isDueDateActive == true &&
                        (status == "ACTIVE" ||
                            status == "DU" ||
                            status == "FREEZE")
                    ? Column(
                        key: UniqueKey(),
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          const Text(
                            "Periode bulan ini sudah jatuh tempo, segera lakukan pembayaran",
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PaymentMethodExisting(
                                    taskid: "$customerID",
                                  ),
                                ),
                              );
                            },
                            child: SizedBox(
                              width: double.infinity * 2,
                              child: Card(
                                elevation: 4, // Tingkat elevasi card
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      15), // Bentuk sudut card
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        15), // Bentuk sudut container
                                    image: const DecorationImage(
                                      image: AssetImage(
                                          'images/bb_red_orange.jpg'), // Gambar background
                                      fit: BoxFit
                                          .cover, // Menyesuaikan gambar dengan ukuran container
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(18.0),
                                    child: ListTile(
                                      title: Text(
                                        "$dueDate",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Text(
                                        "$billing",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      trailing:
                                          const Icon(Icons.arrow_forward_ios),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : const SizedBox(),

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
                              builder: (context) => UpgradeDowngradeDetail(
                                    task: customerID ?? "",
                                    sid: '',
                                  )),
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
                                    'Downgrade / Upgrade',
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
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const MapSample(),
                                    ),
                                  );
                                },
                                child: const Text("Terima"),
                              ),
                            ],
                          );
                        },
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
                        // GestureDetector(
                        //   onTap: () {
                        //     // Navigasi ke halaman yang diinginkan
                        //     Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //           builder: (context) =>
                        //               const PenawaranPage()), // Ganti dengan halaman yang diinginkan
                        //     );
                        //   },
                        //   child: const Text(
                        //     'Lihat Semuanya',
                        //     style: TextStyle(
                        //       fontSize: 10,
                        //       color: Color.fromARGB(255, 228, 99, 7),
                        //       fontWeight: FontWeight.bold,
                        //     ),
                        //   ),
                        // ),
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
                                    description: '1. Streaming Video HD Tanpa Buffering.\n2. Panggilan Video Berkualitas Tinggi.\n3. Koneksi Stabil Untuk 1-3 Perangkat.',

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
                                    description: '1. Ideal untuk bisnis menengah yang membutuhkan akses cepat untuk aplikasi cloud dan video conferencing berkualitas tinggi.\n2. Bandwidth yang cukup untuk mendukung beberapa pengguna sekaligus.\n3. Dukungan teknis 24/7.',
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
                                    description: '1. Direkomendasikan untuk bisnis dengan penggunaan data tinggi seperti e-commerce, video streaming, dan kolaborasi online.\n2. Kecepatan tinggi untuk mengunduh dan mengunggah file besar.\n3. Dukungan teknis prioritas 24/7.',


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
