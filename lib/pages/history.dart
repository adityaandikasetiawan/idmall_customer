// ignore_for_file: non_constant_identifier_names

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:idmall/models/customer_list..dart';
import 'package:idmall/pages/customer_status.dart';
import 'package:idmall/pages/history_payment.dart';
import 'package:idmall/service/coverage_area.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:idmall/config/config.dart' as config;

class HistoryList extends StatefulWidget {
  final String? customerId;
  final String? status;
  const HistoryList({
    super.key,
    this.customerId,
    this.status,
  });

  @override
  State<HistoryList> createState() => _HistoryListState();
}

class _HistoryListState extends State<HistoryList> {
  DateTime now = DateTime.now();
  String? userID;
  String? total_active;
  final oCcy = NumberFormat("#,##0", "en_US");
  final dateFormatter = DateFormat('yyyy-MM-dd');
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Dio dio = Dio();

  @override
  void initState() {
    super.initState();
    getNameUser();
  }

  Future<Null> getNameUser() async {
    WidgetsFlutterBinding.ensureInitialized();
    final SharedPreferences prefs = await _prefs;

    setState(() {
      userID = prefs.getString('email');
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Center(child: Text("History")),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Pembayaran'),
              Tab(text: 'Aktivasi'),
            ],
            indicatorColor:
                Colors.orange, // Warna latar belakang tab saat aktif
            labelColor: Colors.orange, // Warna teks pada tab saat aktif
          ),
        ),
        body: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Container(
            height: 600,
            padding: const EdgeInsets.symmetric(
              horizontal: 25,
            ),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 600,
                    child: TabBarView(
                      children: [
                        const HistoryPayment(),
                        CustomerStatus(
                          status: widget.status ?? "",
                          taskid: widget.customerId ?? "",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HistoryPaymentPage extends StatelessWidget {
  const HistoryPaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildPromotionCard(
            context,
            'images/promo1.png',
            'Promosi 1',
            'Deskripsi Promosi 1',
          ),
          _buildPromotionCard(
            context,
            'images/promo1.png',
            'Promosi 4',
            'Deskripsi Promosi 4',
          ),
          _buildPromotionCard(
            context,
            'images/promo2.png',
            'Puasa tuh nahan lapar & haus, internetannya jangan ditahan!',
            'Internet idPlay unlimited bebas kuota lagi promo, nih. Cocok buat kaum mendang-mending. Cus, cek promonya!',
          ),
        ],
      ),
    );
  }

  Widget _buildPromotionCard(
    BuildContext context,
    String imagePath,
    String title,
    String description,
  ) {
    return Column(
      children: [
        Card(
          margin: const EdgeInsets.all(0),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          child: SizedBox(
            height: 200,
            width: 380,
            child: ClipRRect(
              borderRadius: BorderRadius.zero,
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const Divider(
          color: Colors.white,
          thickness: 0.5,
        ),
        ListTile(
          title: Text(
            title,
            style: const TextStyle(
              color: Color.fromARGB(255, 0, 0, 0), // Warna teks menjadi orange
            ),
          ),
          subtitle: Text(description),
        ),
      ],
    );
  }
}

class HistoryActivationPage extends StatefulWidget {
  const HistoryActivationPage({super.key});

  @override
  State<HistoryActivationPage> createState() => _HistoryActivationPageState();
}

class _HistoryActivationPageState extends State<HistoryActivationPage> {
  final dateFormatter = DateFormat('yyyy-MM-dd');

  Future<List<CustomerListAchieve>> getAchievementList() async {
    WidgetsFlutterBinding.ensureInitialized();
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token') ?? "";
    List<CustomerListAchieve> list = [];

    final response = await dio.get(
      "${config.backendBaseUrl}/transaction/history",
      options: Options(headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      }),
    );
    if (response.data['status'] == 'success') {
      var hasil = response.data['data'];
      for (var ele in hasil) {
        list.add(CustomerListAchieve.fromJson(ele));
      }
      return list;
    } else {
      return List.empty();
    }
  }

  @override
  Widget build(BuildContext context) {
    Future<List<CustomerListAchieve>> postsFuture = getAchievementList();
    return FutureBuilder<List<CustomerListAchieve>>(
      future: postsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasData) {
          final posts = snapshot.data!;
          return buildPosts(posts);
        } else {
          return const Text("No data available");
        }
      },
    );
  }

  Widget buildPosts(List<CustomerListAchieve> posts) {
    // ListView Builder to show data in a list
    return ListView.builder(
      shrinkWrap: true,
      primary: false,
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        return Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ListTile(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (builder) => CustomerStatus(
                          status: post.status, taskid: post.taskID),
                    ),
                  );
                },
                leading: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.account_box_rounded,
                      size: 40,
                    ),
                  ],
                ),
                isThreeLine: true,
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Reg. No: ${post.taskID}"),
                    Text("Status: ${post.status}"),
                    Text("Product: ${post.serviceName}"),
                  ],
                ),
                subtitle: const Text(""),
              ),
            ],
          ),
        );
      },
    );
  }
}
