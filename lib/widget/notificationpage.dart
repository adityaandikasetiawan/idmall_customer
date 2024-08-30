import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:idmall/models/notification.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:idmall/config/config.dart' as config;
import 'package:intl/date_symbol_data_local.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final Dio dio = Dio();
  late List<NotificationResponse> notifications;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    fetchNotifications();
  }

  Future<List<NotificationResponse>> fetchNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String token = prefs.getString('token') ?? "";

      final response = await dio.get(
        "${config.backendBaseUrl}/notification/get/all",
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token"
          },
        ),
      );
      if (response.statusCode == 200) {
        List<dynamic> responseData = response.data['data'] as List<dynamic>;
        List<NotificationResponse> notifications = responseData
            .map((data) => NotificationResponse.fromJson(data))
            .toList();
        return notifications;
      } else {
        throw Exception('Failed to load notifications');
      }
    } on DioException catch (e) {
      throw Exception('Failed to fetch data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
            future: fetchNotifications(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                List<NotificationResponse>? notifications = snapshot.data;

                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: notifications?.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        ListTile(
                          title: Text(DateFormat('MMMMEEEEd', 'id')
                              .format(DateTime.tryParse(
                                  notifications![index].createdAt)!)
                              .toString()),
                          subtitle: Column(
                            children: [
                              ListView.builder(
                                shrinkWrap: true,
                                itemCount:
                                    notifications[index].notifications.length,
                                itemBuilder: (context, index2) {
                                  return ListTile(
                                    title: Text(notifications[index]
                                        .notifications[index2]
                                        .title),
                                    subtitle: Text(notifications[index]
                                        .notifications[index2]
                                        .message),
                                  );
                                },
                              )
                            ],
                          ),
                        ),
                        const Divider(),
                      ],
                    );
                  },
                );
              }
            }),
      ),
    );
  }
}
