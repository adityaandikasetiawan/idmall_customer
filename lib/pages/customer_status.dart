// ignore_for_file: empty_catches

import 'package:flutter/material.dart';
import 'package:idmall/pages/fab_testing.dart';
import 'package:idmall/pages/pembayaran_testing.dart';
import 'package:idmall/pages/upgrade_downgrade_detail.dart';
import 'package:idmall/widget/status_timeline.dart';
import 'package:idmall/config/config.dart' as config;
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:timeline_tile/timeline_tile.dart';

class CustomerStatus extends StatefulWidget {
  final String status;
  final String taskid;
  const CustomerStatus({
    super.key,
    required this.status,
    required this.taskid,
  });

  @override
  State<CustomerStatus> createState() => _CustomerStatusState();
}

class _CustomerStatusState extends State<CustomerStatus> {
  @override
  void initState() {
    super.initState();
    setState(() {
      status = widget.status;
    });
    getStatusDate();
  }

  final dateFormatter = DateFormat('yyyy-MM-dd');

  String? createdDate;
  String? surveyDate;
  String? quotationDate;
  String? fabDate;
  String? spkDate;
  String? activationDate;

  String? status;

  List<String> statusCreated = [
    "CREATED",
    "QUOTATION",
    "ON SURVEY",
    "PENGAJUAN",
    "DESKTOP SURVEY",
    "SPK_REQ",
    "SPK",
    "PENDING_PAYMENT_MOBILE",
    "FAB",
    "ACTIVE_REQ",
    "ACTIVE"
  ];
  List<String> statusSurvey = [
    "QUOTATION",
    "ON SURVEY",
    "DESKTOP SURVEY",
    "SPK",
    "FAB",
    "SPK_REQ",
    "PENDING_PAYMENT_MOBILE",
    "ACTIVE_REQ",
    "ACTIVE"
  ];
  List<String> statusFAB = [
    "QUOTATION",
    "SPK_REQ",
    "FAB",
    "SPK",
    "PENDING_PAYMENT_MOBILE",
    "ACTIVE_REQ",
    "ACTIVE"
  ];
  List<String> statusPayment = [
    "PENDING_PAYMENT_MOBILE",
    "SPK_REQ",
    "SPK",
    "ACTIVE_REQ",
    "ACTIVE"
  ];
  List<String> statusSPK = ["SPK_REQ", "SPK", "ACTIVE_REQ", "ACTIVE"];
  List<String> statusReqActive = ["SPK", "ACTIVE_REQ", "ACTIVE"];
  List<String> statusActive = ["ACTIVE"];

  Future<void> getStatusDate() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String token = prefs.getString('token') ?? "";
      final dio = Dio();
      final response = await dio.get(
          "${config.backendBaseUrl}/sales/detail-status-customer",
          options: Options(headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
            "Cache-Control": "no-cache"
          }),
          data: {
            "status": widget.status,
            "task_id": widget.taskid,
          });
      setState(() {
        createdDate = dateFormatter.format(
            DateTime.tryParse(response.data['data'][0]['Created_Date'])!);
        surveyDate = response.data['data'][0]['M_Survey_Date'] != null
            ? dateFormatter.format(
                DateTime.tryParse(response.data['data'][0]['M_Survey_Date'])!)
            : "";
        fabDate = response.data['data'][0]['FAB_Date'] != null
            ? dateFormatter.format(
                DateTime.tryParse(response.data['data'][0]['FAB_Date'])!)
            : "";
        spkDate = response.data['data'][0]['M_SPK_Date'] != null
            ? dateFormatter.format(
                DateTime.tryParse(response.data['data'][0]['M_SPK_Date'])!)
            : "";
        activationDate = response.data['data'][0]['Activation_Date'] != null
            ? dateFormatter.format(
                DateTime.tryParse(response.data['data'][0]['Activation_Date'])!)
            : "";
        status = response.data['data'][0]['Status'];
      });
    } on DioException {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: getStatusDate,
        child: Center(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            children: [
              //Created
              StatusTimeline(
                key: UniqueKey(),
                isFirst: true,
                isLast: false,
                isPast: statusCreated.contains(status),
                title: "Registrasi",
                subtile: statusCreated.contains(status)
                    ? "Register Date : $createdDate"
                    : "",
              ),
              //survey
              StatusTimeline(
                key: UniqueKey(),
                isFirst: false,
                isLast: false,
                isPast: statusSurvey.contains(status) ? true : false,
                title: "Survey",
                subtile: statusSurvey.contains(status)
                    ? "Survey Date : $surveyDate"
                    : "",
              ),
              //fab
              SizedBox(
                child: TimelineTile(
                  key: UniqueKey(),
                  isFirst: false,
                  isLast: false,
                  beforeLineStyle: LineStyle(
                    color: statusFAB.contains(status)
                        ? Colors.deepOrange.shade400
                        : Colors.deepOrange.shade100,
                  ),
                  indicatorStyle: IndicatorStyle(
                    width: 40,
                    color: statusFAB.contains(status)
                        ? Colors.deepOrange.shade400
                        : Colors.deepOrange.shade100,
                    iconStyle: IconStyle(
                      iconData: Icons.done,
                      color: Colors.white,
                    ),
                  ),
                  endChild: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(20),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: statusFAB.contains(status)
                              ? Colors.deepOrange.shade400
                              : Colors.deepOrange.shade200,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              title: Text(
                                'Pengisian Form',
                                style: TextStyle(
                                    color: statusFAB.contains(status)
                                        ? Colors.white
                                        : Colors.black),
                              ),
                              subtitle: Text(
                                statusFAB.contains(status)
                                    ? "FAB Date : $fabDate"
                                    : '',
                                style: TextStyle(
                                    color: statusFAB.contains(status)
                                        ? Colors.white
                                        : Colors.black),
                              ),
                            ),
                            statusFAB.contains(status)
                                ? TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => FABTesting(
                                                  taskID: widget.taskid,
                                                )),
                                      );
                                    },
                                    child: const Text('Lanjut'))
                                : Container(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              //SPK
              TimelineTile(
                key: UniqueKey(), // Tambahkan kunci unik di sini
                isFirst: false,
                isLast: false,
                beforeLineStyle: LineStyle(
                  color: statusPayment.contains(status)
                      ? Colors.deepOrange.shade400
                      : Colors.deepOrange.shade100,
                ),
                indicatorStyle: IndicatorStyle(
                  width: 40,
                  color: statusPayment.contains(status)
                      ? Colors.deepOrange.shade400
                      : Colors.deepOrange.shade100,
                  iconStyle: IconStyle(
                    iconData: Icons.done,
                    color: Colors.white,
                  ),
                ),
                endChild: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(20),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: statusPayment.contains(status)
                            ? Colors.deepOrange.shade400
                            : Colors.deepOrange.shade200,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            title: Text(
                              'Payment',
                              style: TextStyle(
                                  color: statusPayment.contains(status)
                                      ? Colors.white
                                      : Colors.black),
                            ),
                            subtitle: Text(
                              statusPayment.contains(status)
                                  ? "Paid Date : $spkDate"
                                  : '',
                              style: TextStyle(
                                  color: statusPayment.contains(status)
                                      ? Colors.white
                                      : Colors.black),
                            ),
                          ),
                          !statusReqActive.contains(status)
                              ? TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        // builder: (context) => OrderData(taskID: widget.taskid,)),
                                        builder: (context) => PaymentMethod(
                                          taskid: widget.taskid,
                                        ),
                                      ),
                                    );
                                  },
                                  child: const Text('Bayar'))
                              : Container(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              //Req Active
              StatusTimeline(
                key: UniqueKey(), // Tambahkan kunci unik di sini
                isFirst: false,
                isLast: false,
                isPast: statusReqActive.contains(status) ? true : false,
                title: "Installation",
                subtile: statusReqActive.contains(status)
                    ? "Installation Date : $activationDate"
                    : "",
              ),
              //active
              TimelineTile(
                key: UniqueKey(), // Tambahkan kunci unik di sini
                isFirst: false,
                isLast: true,
                beforeLineStyle: LineStyle(
                  color: statusActive.contains(status)
                      ? Colors.deepOrange.shade400
                      : Colors.deepOrange.shade100,
                ),
                indicatorStyle: IndicatorStyle(
                  width: 40,
                  color: statusActive.contains(status)
                      ? Colors.deepOrange.shade400
                      : Colors.deepOrange.shade100,
                  iconStyle: IconStyle(
                    iconData: Icons.done,
                    color: Colors.white,
                  ),
                ),
                endChild: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(20),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: statusActive.contains(status)
                            ? Colors.deepOrange.shade400
                            : Colors.deepOrange.shade200,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            title: Text(
                              'Active',
                              style: TextStyle(
                                  color: statusActive.contains(status)
                                      ? Colors.white
                                      : Colors.black),
                            ),
                            subtitle: Text(
                              statusActive.contains(status)
                                  ? "Active Date : $activationDate"
                                  : '',
                              style: TextStyle(
                                  color: statusActive.contains(status)
                                      ? Colors.white
                                      : Colors.black),
                            ),
                          ),
                          statusActive.contains(status)
                              ? TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        // builder: (context) => OrderData(taskID: widget.taskid,)),
                                        builder: (context) =>
                                            UpgradeDowngradeDetail(
                                          task: widget.taskid,
                                          sid: '',
                                        ),
                                      ),
                                    );
                                  },
                                  child: const Text('Upgrade'))
                              : Container(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
