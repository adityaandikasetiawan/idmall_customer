import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:idmall/consts.dart';
import 'package:idmall/models/update_downgrade.dart';
import 'package:idmall/pages/upgrade_downgrade_detail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:idmall/config/config.dart' as config;
import 'package:intl/intl.dart';

class UpdateDownGrade extends StatefulWidget {
  const UpdateDownGrade({super.key});

  @override
  State<UpdateDownGrade> createState() => _UpdateDownGradeState();
}

class _UpdateDownGradeState extends State<UpdateDownGrade> {
  String? firstName;
  String? lastName;
  String? _token;
  double? latitude;
  double? longitude;
  bool _isLoading = false;
  Dio dio = Dio();
  List<UpdateDownGradeModel> _data = [];
  List<UpdateDownGradeModel>? _filterData;
  TextEditingController _filterController = TextEditingController();

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  @override
  void initState() {
    super.initState();
    getNameUser();
    getFutureDone();
  }

  onSortColumn(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      if (ascending) {
        _filterData!
            .sort((a, b) => a.customerSubName.compareTo(b.customerSubName));
      } else {
        _filterData!
            .sort((a, b) => b.customerSubName.compareTo(a.customerSubName));
      }
    }
  }

  Future<Null> getNameUser() async {
    WidgetsFlutterBinding.ensureInitialized();
    final SharedPreferences? prefs = await _prefs;

    setState(() {
      firstName = prefs?.getString('firstName');
      lastName = prefs?.getString('lastName');
      _token = prefs?.getString('token');
    });
  }

  void _loadMoreData() {
    if (!_isLoading) {
      setState(() {});
      getFutureDone();
    }
  }

  Future<void> getFutureDone() async {
    WidgetsFlutterBinding.ensureInitialized();
    setState(() {
      _isLoading = true;
    });
    final SharedPreferences? prefs = await _prefs;
    final token = prefs?.getString("token");
    final response = await dio.get(
      "${config.backendBaseUrl}/sales/filter-customer-list/ACTIVE",
      options: Options(headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      }),
    );
    // print(response.data['data']);
    if (response.data['message'] == 'success') {
      var hasil = response.data['data'];
      List<UpdateDownGradeModel> list = [];
      for (var ele in hasil) {
        list.add(UpdateDownGradeModel.fromJson(ele));
      }
      setState(() {
        _data = list;
        _filterData = _data;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
    print(_data.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("List Update / Downgrade"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              const SizedBox(
                height: 20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("LIST CUSTOMER"),
                  ],
                ),
              ),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Center(
                        child: SizedBox(
                          height: 700,
                          width: screenWidth(context),
                          child: PaginatedDataTable(
                            header: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey,
                                  ),
                                  borderRadius: BorderRadius.circular(10)),
                              child: TextField(
                                controller: _filterController,
                                decoration: InputDecoration(
                                  hintText: "Type here to Filter",
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    _data = _filterData!
                                        .where((element) => element
                                            .customerSubName
                                            .contains(value))
                                        .toList();
                                    _data += _filterData!
                                        .where((element) =>
                                            element.taskID.contains(value))
                                        .toList();
                                  });
                                },
                              ),
                            ),
                            columns: const [
                              DataColumn(label: Text('No')),
                              DataColumn(label: Text('Customer ID')),
                              DataColumn(label: Text('Customer Name')),
                              DataColumn(label: Text('Provider ID')),
                              DataColumn(label: Text('Provider Name')),
                              DataColumn(label: Text('Service')),
                              DataColumn(label: Text('Address')),
                              DataColumn(label: Text('City')),
                              DataColumn(label: Text('Region')),
                              DataColumn(label: Text('Email')),
                              DataColumn(label: Text('Activation Date')),
                              DataColumn(label: Text('Monthly Price')),
                            ],
                            // source: DataSourceFreeze(token:token, items: getFutureDone(dio, token, 10, 10)),
                            source: _DataActiveList(
                              token: _token,
                              items: _data,
                              context: context,
                            ),
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DataActiveList extends DataTableSource {
  String? token;
  List<UpdateDownGradeModel> items;
  Dio dio = Dio();
  BuildContext context;
  final oCcy = new NumberFormat("#,##0", "en_US");

  _DataActiveList(
      {required this.token, required this.items, required this.context});

  @override
  DataRow? getRow(int index) {
    if (index >= items.length) {
      return null;
    }
    final item = items[index];
    return DataRow(
        onLongPress: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => UpgradeDowngradeDetail(
                        task: item.taskID,
                        sid: item.customerID,
                      )));
        },
        cells: [
          DataCell(Text(item.orderNo.toString())),
          DataCell(Text(item.taskID)),
          DataCell(Text(item.customerSubName)),
          DataCell(Text(item.customerID)),
          DataCell(Text(item.customerName)),
          DataCell(Text(item.subProduct)),
          DataCell(Text(item.customerSubAddress)),
          DataCell(Text(item.city)),
          DataCell(Text(item.region)),
          DataCell(Text(item.emailCustomer)),
          DataCell(Text(DateFormat('yyyy-MM-dd')
              .format(DateTime.tryParse(item.activationDate)!)
              .toString())),
          DataCell(Text(
              oCcy.format(item.monthlyPrice).toString().replaceAll(",", "."))),
        ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => items.length;

  @override
  // Future<void> nextPage() async {
  //   if (!_loading) {
  //     _loading = true;
  //     try {
  //       final newItems = await getFutureDone();
  //       items!.addAll(newItems);
  //       _page++;
  //     } catch (e) {
  //       print('Error fetching data: $e');
  //     } finally {
  //       _loading = false;
  //       notifyListeners();
  //     }
  //   }
  // }

  @override
  int get selectedRowCount => 0;
}
