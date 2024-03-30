import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'dart:ffi';
import 'package:dio/io.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:idmall/consts.dart';
import 'package:idmall/models/customer_list..dart';
import 'package:idmall/pages/customer_status.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:idmall/config/config.dart' as config;

class HistoryList extends StatefulWidget {
  const HistoryList({super.key});

  @override
  State<HistoryList> createState() => _HistoryListState();
}

class _HistoryListState extends State<HistoryList> {
  DateTime now = DateTime.now();
  String? token;
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
    final SharedPreferences? prefs = await _prefs;

    setState(() {
      token = prefs?.getString('token');
      userID = prefs?.getString('email');
    });
  }

  static Future<List<CustomerListAchieve>> getAchievementList(
      dio, now, token, dateFormatter, userID) async {
    WidgetsFlutterBinding.ensureInitialized();
    final date = dateFormatter.format(now);

    (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () =>
        HttpClient()
          ..badCertificateCallback =
              (X509Certificate cert, String host, int port) => true;
    var response = await dio.get("$linkLaravelAPI/customer/history-list",
        queryParameters: {"date": date},
        options: Options(headers: {
          HttpHeaders.authorizationHeader: token,
        }));
    if (jsonDecode(response.data)['status'] == 'success') {
      var hasil = jsonDecode(response.data)['data'];
      var user = hasil[userID];
      // for (var ele in user) {
      //   print(ele);
      // }
      // print(hasil);
      // print(model[0]);
      // print(user);
      // user = user.map((e) => CustomerListAchieve.fromJson(e)).toList();
      //   print(user);
      List<CustomerListAchieve> list = [];
      // for (var i = 0; i < user.length; i++) {
      //   list.add(CustomerListAchieve.fromJson(user[i]));
      // }
        // print(user);
        user.forEach((key, ele) {
          list.add(CustomerListAchieve.fromJson(ele));
        });
      // for (var ele in user) {
      //   //   // var name = productModel.name.toString();
      //   //   // var taskID = productModel.taskID.toString();
      //   //   // var price = productModel.price.toString();
      //   list.add(CustomerListAchieve.fromJson(ele));
      // }
      return list;
    }
    // print(jsonDecode(response.data));
    return List.empty();
  }

  @override
  Widget build(BuildContext context) {
    Future<List<CustomerListAchieve>> postsFuture =
        getAchievementList(dio, now, token, dateFormatter, userID);
    // Future<List<CustomerListAchieve>> postsFuture = getAchievementList();
    return Scaffold(
      appBar: AppBar(
        title: const Text("History"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 25,
          ),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // const SizedBox(
                //   height: 20,
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                //     children: [
                //       Text("LIST CUSTOMER"),
                //     ],
                //   ),
                // ),
                SizedBox(
                  // height: 600,
                  child: FutureBuilder<List<CustomerListAchieve>>(
                    future: postsFuture,
                    builder: (context, snapshot) {
                      snapshot.connectionState == ConnectionState.done
                          ? print('DONE')
                          : print('loading');
                      if (snapshot.connectionState == ConnectionState.waiting) {
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
                // Card(
                //   child: ListView.builder(
                //     shrinkWrap: true,
                //     itemCount: _listCustomer?.length,
                //     itemBuilder: (BuildContext context, int index) {
                //       return ListTile(
                //         onTap: () {
                //           debugPrint('Contoh');
                //         },
                //         leading: const Column(
                //           mainAxisAlignment: MainAxisAlignment.center,
                //           children: [
                //             Icon(
                //               Icons.account_box_rounded,
                //               size: 40,
                //             ),
                //           ],
                //         ),
                //         isThreeLine: true,
                //         title: Column(
                //           crossAxisAlignment: CrossAxisAlignment.start,
                //           mainAxisSize: MainAxisSize.min,
                //           children: [
                //             Text(_listCustomer?[index]['name'] ?? ''),
                //             Text(_listCustomer?[index]['taskID'] ?? ''),
                //           ],
                //         ),
                //         subtitle: Text(_listCustomer?[index]['activeDate'] ?? ''),
                //       );
                //     }
                //   )
                // ),
              ],
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
      physics: NeverScrollableScrollPhysics(),
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
                  debugPrint('Contoh');
                  Navigator.of(context).push(MaterialPageRoute(builder:  (builder) => CustomerStatus(status: post.status, taskid: post.taskID)));
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
                subtitle: Text(post.activeDate),
              ),
            ],
          ),
        );
      },
    );
  }
}
