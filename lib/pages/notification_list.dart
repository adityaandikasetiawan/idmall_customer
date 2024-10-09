import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:idmall/controller/notification.controller.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:idmall/models/notification.dart';
import 'package:intl/intl.dart';

class NotificationList extends StatefulWidget {
  const NotificationList({super.key});

  @override
  State<NotificationList> createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  final NotificationController notificationController =
      Get.put(NotificationController());

  @override
  void initState() {
    super.initState();
    notificationController.fetchNotification();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notification"),
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Obx(
          () {
            if (notificationController.isLoading.value) {
              return Center(
                child: SpinKitFadingCircle(
                  color: Colors.grey,
                  size: 50.0,
                ),
              );
            } else {
              if (notificationController.notificationList.isEmpty) {
                return Center(
                  child: Text("Tidak ada notifikasi"),
                );
              } else {
                return ListView.separated(
                  separatorBuilder: (context, index) {
                    return Divider();
                  },
                  itemCount: notificationController.notificationList.length,
                  itemBuilder: (context, index) {
                    NotificationResponse notificationMain =
                        notificationController.notificationList[index];

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            DateFormat('EEE, d MMM yyyy').format(
                                DateTime.parse(notificationMain.createdAt)),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        ListView.separated(
                          separatorBuilder: (context, index) {
                            return Divider(
                              height: 2,
                            );
                          },
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: notificationMain.notifications.length,
                          itemBuilder: (context, index2) {
                            NotificationModel notificationList =
                                notificationMain.notifications[index2];
                            return Container(
                              color: notificationList.read == 0
                                  ? Colors.grey[200]
                                  : Colors.transparent,
                              child: ListTile(
                                title: Text(notificationList.title),
                                subtitle: Text(notificationList.message),
                                onTap: () {
                                  notificationController.readNotification(
                                      notificationList.id.toString());
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  },
                );
              }
            }
          },
        ),
      ),
    );
  }
}
