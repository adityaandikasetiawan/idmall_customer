import 'package:flutter/material.dart';
import 'package:idmall/pages/activation.dart';
import 'package:idmall/pages/fab.dart';
import 'package:idmall/pages/order_data.dart';
import 'package:idmall/widget/pesanan.dart';
import 'package:idmall/widget/status_timeline.dart';
import 'package:idmall/config/config.dart' as config;
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:idmall/widget/event_card.dart';
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
    getStatusDate();
  }

  final dateFormatter = DateFormat('yyyy-MM-dd');

  String? createdDate;
  String? surveyDate;
  String? quotationDate;
  String? fabDate;
  String? spkDate;
  String? activationDate;

  List<String> statusCreated = [
    "ON SURVEY",
    "PENGAJUAN",
    "DESKTOP SURVEY",
    "TERCOVER",
    "SPK_REQ",
    "SPK",
    "PENDING PAYMENT",
    "FAB",
    "ACTIVE_REQ",
    "ACTIVE"
  ];
  List<String> statusSurvey = [
    "ON SURVEY",
    "DESKTOP SURVEY",
    "TERCOVER",
    "SPK_REQ",
    "SPK",
    "PENDING PAYMENT",
    "ACTIVE_REQ",
    "ACTIVE"
  ];
  List<String> statusFAB = [
    "TERCOVER",
    "SPK_REQ",
    "SPK",
    "PENDING PAYMENT",
    "ACTIVE_REQ",
    "ACTIVE"
  ];
  List<String> statusPayment = [
    "TERCOVER",
    "PENDING PAYMENT",
    "SPK_REQ",
    "SPK",
    "ACTIVE_REQ",
    "ACTIVE"
  ];
  List<String> statusSPK = ["PENDING PAYMENT", "ACTIVE_REQ", "ACTIVE"];
  List<String> statusReqActive = ["ACTIVE_REQ", "ACTIVE"];

  Future<void> getStatusDate() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String token = prefs.getString('token') ?? "";
      final dio = Dio();
      final response = await dio.get(
          "${config.backendBaseUrl}/sales/detail-status-customer",
          options: Options(headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token"
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
      });
    } on DioException catch (e) {
      print(e.message);
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Status Customer"),
      ),
      body: Center(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 25),
          children: [
            //Created
            StatusTimeline(
              isFirst: true,
              isLast: false,
              isPast: statusCreated.contains(widget.status),
              title: "Registrasi",
              subtile: statusCreated.contains(widget.status)
                  ? "Register Date : ${createdDate}"
                  : "",
            ),
            //survey
            StatusTimeline(
              isFirst: false,
              isLast: false,
              isPast: statusSurvey.contains(widget.status) ? true : false,
              title: "Survey",
              subtile: statusSurvey.contains(widget.status)
                  ? "Survey Date : ${surveyDate}"
                  : "",
            ),
            //fab
            SizedBox(
              child: TimelineTile(
                isFirst: false,
                isLast: false,
                beforeLineStyle: LineStyle(
                  color: statusPayment.contains(widget.status) ? Colors.deepOrange.shade400 : Colors.deepOrange.shade100,
                ),
                indicatorStyle: IndicatorStyle(
                  width: 40,
                  color: statusPayment.contains(widget.status) ? Colors.deepOrange.shade400 : Colors.deepOrange.shade100,
                  iconStyle: IconStyle(
                    iconData: Icons.done,
                    color: Colors.white,
                  ),
                ),
                endChild: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.all(20),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color:  statusPayment.contains(widget.status) ? Colors.deepOrange.shade400 : Colors.deepOrange.shade200,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            title: Text(
                              'FAB',
                              style:
                                  TextStyle(color:  statusPayment.contains(widget.status) ? Colors.white : Colors.black),
                            ),
                            subtitle: Text(
                              statusFAB.contains(widget.status) ? "FAB Date : ${fabDate}" : '',
                              style:
                                  TextStyle(color: statusPayment.contains(widget.status) ? Colors.white : Colors.black),
                            ),
                          ),
                          !statusSPK.contains(widget.status) ?
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => FABForm(taskID: widget.taskid,)),
                                );
                            },
                            child: Text('Lanjut')
                          ) : Container(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // StatusTimeline(
            //   isFirst: false,
            //   isLast: false,
            //   isPast: statusPayment.contains(widget.status) ? true : false,
            //   title: "FAB",
            //   subtile: statusFAB.contains(widget.status)
            //       ? "FAB Date : ${fabDate}"
            //       : "",
            // ),
            //SPK
            SizedBox(
              child: TimelineTile(
                isFirst: false,
                isLast: false,
                beforeLineStyle: LineStyle(
                  color: statusSPK.contains(widget.status) ? Colors.deepOrange.shade400 : Colors.deepOrange.shade100,
                ),
                indicatorStyle: IndicatorStyle(
                  width: 40,
                  color: statusSPK.contains(widget.status) ? Colors.deepOrange.shade400 : Colors.deepOrange.shade100,
                  iconStyle: IconStyle(
                    iconData: Icons.done,
                    color: Colors.white,
                  ),
                ),
                endChild: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.all(20),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color:  statusSPK.contains(widget.status) ? Colors.deepOrange.shade400 : Colors.deepOrange.shade200,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            title: Text(
                              'Payment',
                              style:
                                  TextStyle(color:  statusSPK.contains(widget.status) ? Colors.white : Colors.black),
                            ),
                            subtitle: Text(
                              statusFAB.contains(widget.status) ? "Paid Date : ${spkDate}" : '',
                              style:
                                  TextStyle(color: statusSPK.contains(widget.status) ? Colors.white : Colors.black),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => OrderData(taskID: widget.taskid,)),
                                );
                            },
                            child: Text('Lanjut')
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            //Req Active
            StatusTimeline(
              isFirst: false,
              isLast: false,
              isPast: statusReqActive.contains(widget.status) ? true : false,
              title: "Installation",
              subtile: statusReqActive.contains(widget.status)
                  ? "Installation Date : ${activationDate}"
                  : "",
            ),
            //active
            StatusTimeline(
              isFirst: false,
              isLast: true,
              isPast: (widget.status == "ACTIVE") ? true : false,
              title: "Active",
              subtile: (widget.status == "ACTIVE") ? "${activationDate}" : "",
            ),
          ],
        ),
      ),
    );
  }
}
