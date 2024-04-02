import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:idmall/models/customer_list..dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:idmall/pages/customer_status.dart';
import 'package:idmall/config/config.dart' as config;

void main() {
  runApp(MaterialApp(
    home: NotificationsPage(),
  ));
}

class NotificationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Notifications',
            style: TextStyle(fontSize: 16),
          ),
          centerTitle: true,
          bottom: TabBar(
            tabs: [
              Tab(text: 'Informasi'), // Ganti "Promosi" menjadi "Informasi"
              Tab(text: 'Histori'),
            ],
            indicatorColor:
                Colors.orange, // Warna latar belakang tab saat aktif
            labelColor: Colors.orange, // Warna teks pada tab saat aktif
          ),
        ),
        body: TabBarView(
          children: [
            InformationPage(),
            HistoryList(),
          ],
        ),
      ),
    );
  }
}

class InformationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildInformationCard(
            context,
            'Informasi Tagihan',
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
          ),
          _buildInformationCard(
            context,
            'Pemberitahauan Penting',
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
          ),
          _buildInformationCard(
            context,
            'Peringatan Pembayaran',
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
          ),
          _buildInformationCard(
            context,
            'Promosi',
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
          ),
        ],
      ),
    );
  }

  Widget _buildInformationCard(
    BuildContext context,
    String title,
    String description,
  ) {
    return Card(
      color: Colors.white,
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 5),
            Text(description),
          ],
        ),
        trailing: Text(
          DateFormat('dd MMMM yyyy').format(DateTime.now()), // Tanggal update sekarang
          style: TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

class HistoryList extends StatefulWidget {
  const HistoryList({Key? key}) : super(key: key);

  @override
  State<HistoryList> createState() => _HistoryListState();
}

class _HistoryListState extends State<HistoryList> {
  late DateTime now;
  String? userID;
  String? total_active;
  final oCcy = NumberFormat("#,##0", "en_US");
  final dateFormatter = DateFormat('yyyy-MM-dd');
  late Future<SharedPreferences> _prefs;
  late Dio dio;

  @override
  void initState() {
    super.initState();
    now = DateTime.now();
    _prefs = SharedPreferences.getInstance();
    dio = Dio();
    getNameUser();
    getAchievementList();
  }

  Future<void> getNameUser() async {
    WidgetsFlutterBinding.ensureInitialized();
    final SharedPreferences? prefs = await _prefs;

    setState(() {
      userID = prefs?.getString('email');
    });
  }

  Future<List<CustomerListAchieve>> getAchievementList() async {
    WidgetsFlutterBinding.ensureInitialized();
    dateFormatter.format(now);
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
    print(response.data['data']);
    if (response.data['status'] == 'success') {
      var hasil = response.data['data'];
      for (var ele in hasil) {
        list.add(CustomerListAchieve.fromJson(ele));
      }
      return list;
    } else {
      return List.empty();
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final Future<List<CustomerListAchieve>> postsFuture = getAchievementList();
    return Scaffold(
      body: RefreshIndicator(
        color: Colors.white,
        backgroundColor: Colors.blue,
        onRefresh: getAchievementList,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 25,
            ),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    // height: 600,
                    child: FutureBuilder<List<CustomerListAchieve>>(
                      future: postsFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasData) {
                          final posts = snapshot.data!;
                          return buildPosts(posts);
                        } else {
                          return const Text("No data available");
                        }
                      },
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

  // function to display fetched data on screen
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
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (builder) => CustomerStatus(
                            status: post.status,
                            taskid: post.taskID,
                          )));
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
                    Text("Reg. No: " + post.taskID.toString()),
                    Text("Status: " + post.status.toString()),
                    Text("Product: " + post.serviceName.toString()),
                  ],
                ),
                subtitle: Text(""),
              ),
            ],
          ),
        );
      },
    );
  }
}
