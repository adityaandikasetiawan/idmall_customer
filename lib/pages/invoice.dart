import 'dart:io';

import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:idmall/config/config.dart' as config;
import 'package:shared_preferences/shared_preferences.dart';

class Invoice extends StatefulWidget {
  final String code;
  final int totalPrice;
  final String taskID;
  const Invoice({
    super.key,
    required this.code,
    required this.totalPrice,
    required this.taskID,
  });

  @override
  State<Invoice> createState() => _InvoiceState();
}

class _InvoiceState extends State<Invoice> {
  Dio dio = Dio();
  String? token;
  String? codeAccount;
  String? bank;
  int? total;

  Future<void> getInvoice() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    setState(() {
      token = _pref.getString('token');
    });
    try {
      // Replace URL with your endpoint
      (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () =>
          HttpClient()
            ..badCertificateCallback =
                (X509Certificate cert, String host, int port) => true;
      var response =
          await dio.get('${config.backendBaseUrl}/transaction/${widget.taskID}',
              options: Options(headers: {
                HttpHeaders.authorizationHeader: "Bearer $token",
              }));

      // Handle response
      Map<String, dynamic> result = response.data;
      if (result['data']['task_id'] == widget.taskID) {
        print(result);
        setState(() {
          codeAccount = result['data']['code'];
          bank = result['data']['payment_method'];
          total = result['data']['harga'];
        });
      }
      // Navigator.of(context).push(MaterialPageRoute(builder: (builder) => OrderPage()));
    } catch (e) {
      // Handle error
      print(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    getInvoice();
  }

  List<Item> _data = generateItems(3);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
          child: Column(
            children: [
              ContainerWidgetWithRoundedBorder(
                title: 'No Va:',
                subtitle: codeAccount ?? '',
              ),
              // ExpansionPanelList(
              //   expansionCallback: (int index, bool isExpanded) {
              //     print(_data[index].isExpanded);
              //     setState(() {
              //       _data[index].isExpanded = isExpanded;
              //     });
              //   },
              //   children: _data.map<ExpansionPanel>((Item item) {
              //     return ExpansionPanel(
              //       headerBuilder: (BuildContext context, bool isExpanded) {
              //         return ListTile(
              //           title: Text(item.headerValue),
              //         );
              //       },
              //       body: ListTile(
              //         title: Text(item.expandedValue),
              //       ),
              //       isExpanded: item.isExpanded,
              //     );
              //   }).toList(),
              // ),
              SizedBox(height: 15),
              ContainerWidgetWithRoundedBorder(
                title: 'Name:',
                subtitle: bank ?? '',
              ),
              SizedBox(
                height: 15,
              ),
              ContainerWidgetWithRoundedBorder(
                title: 'Total Payment:',
                subtitle: "${total.toString()}",
              ),
              SizedBox(
                height: 15,
              ),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Success'),
                        content: SingleChildScrollView(
                          child: Text(
                            // Your agreement content here
                            'Pembayaran sudah selesai dilakukan',
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              // Navigator.of(context).pop();
                              // Navigator.of(context).pop();
                              // Navigator.of(context).pop();
                              // Navigator.of(context).pop();
                              Navigator.of(context)
                                  .popUntil((route) => route.isFirst);
                            },
                            child: Text('Close'),
                          ),
                          // TextButton(
                          //   onPressed: () {
                          //     // Add your logic for handling agreement acceptance
                          //     // For example, you can set a variable to indicate agreement acceptance
                          //     // _agreeToTerms = true;
                          //     // Then proceed with further actions.
                          //     Navigator.of(context).pop();
                          //   },
                          //   child: Text('I Agree'),
                          // ),
                        ],
                      );
                    },
                  );
                },
                child: Text('Check Payment Status'),
              )
            ],
          ),
        ),
      ),
    );
  }
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text('Pembayaran'),
  //     ),
  //     body: SingleChildScrollView(
  //       child: Container(
  //         padding: EdgeInsets.symmetric(horizontal:15, vertical:10),
  //         child: Column(
  //           children: [
  //             Container(
  //               child: Text('125123124451234'),
  //             ),
  //             SizedBox(height: 30,),
  //             Container(
  //               child: Accordion(
  //                 headerBorderColor: Colors.blueGrey,
  //                 headerBorderColorOpened: Colors.transparent,
  //                 // headerBorderWidth: 1,
  //                 headerBackgroundColorOpened: Colors.green,
  //                 contentBackgroundColor: Colors.white,
  //                 contentBorderColor: Colors.green,
  //                 contentBorderWidth: 3,
  //                 contentHorizontalPadding: 20,
  //                 scaleWhenAnimating: true,
  //                 openAndCloseAnimation: true,
  //                 headerPadding:
  //                     const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
  //                 sectionOpeningHapticFeedback: SectionHapticFeedback.heavy,
  //                 sectionClosingHapticFeedback: SectionHapticFeedback.light,
  //                 children: [
  //                   AccordionSection(
  //                     isOpen: true,
  //                     contentVerticalPadding: 20,
  //                     leftIcon:
  //                         const Icon(Icons.text_fields_rounded, color: Colors.white),
  //                     header: const Text('Simple Text', style: headerStyle),
  //                     content: const Text(loremIpsum, style: contentStyle),
  //                   ),
  //                   AccordionSection(
  //                     isOpen: true,
  //                     leftIcon: const Icon(Icons.input, color: Colors.white),
  //                     header: const Text('Text Field & Button', style: headerStyle),
  //                     contentHorizontalPadding: 40,
  //                     contentVerticalPadding: 20,
  //                     content: const MyInputForm(),
  //                   ),
  //                   AccordionSection(
  //                     isOpen: true,
  //                     leftIcon:
  //                         const Icon(Icons.child_care_rounded, color: Colors.white),
  //                     header: const Text('Nested Accordion', style: headerStyle),
  //                     content: const MyNestedAccordion(),
  //                   ),
  //                   AccordionSection(
  //                     isOpen: false,
  //                     leftIcon: const Icon(Icons.shopping_cart, color: Colors.white),
  //                     header: const Text('DataTable', style: headerStyle),
  //                     content: const MyDataTable(),
  //                   ),
  //                   AccordionSection(
  //                     isOpen: false,
  //                     leftIcon:
  //                         const Icon(Icons.circle_outlined, color: Colors.black54),
  //                     rightIcon: const Icon(
  //                       Icons.keyboard_arrow_down,
  //                       color: Colors.black54,
  //                       size: 20,
  //                     ),
  //                     headerBackgroundColor: Colors.transparent,
  //                     headerBackgroundColorOpened: Colors.amber,
  //                     headerBorderColor: Colors.black54,
  //                     headerBorderColorOpened: Colors.black54,
  //                     headerBorderWidth: 1,
  //                     contentBackgroundColor: Colors.amber,
  //                     contentBorderColor: Colors.black54,
  //                     contentBorderWidth: 1,
  //                     contentVerticalPadding: 30,
  //                     header: const Text('Custom: Header with Border',
  //                         style: TextStyle(
  //                             color: Colors.black54,
  //                             fontSize: 18,
  //                             fontWeight: FontWeight.bold)),
  //                     content: Row(
  //                       mainAxisAlignment: MainAxisAlignment.center,
  //                       children: [
  //                         const Icon(
  //                           Icons.label_important_outline_rounded,
  //                           size: 50,
  //                         ).paddingOnly(right: 20),
  //                         const Flexible(
  //                           child: Text(
  //                             slogan,
  //                             maxLines: 4,
  //                             style: TextStyle(color: Colors.black45, fontSize: 17),
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ]
  //               )
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
}

class ContainerWidgetWithRoundedBorder extends StatelessWidget {
  final String title;
  final String subtitle;
  const ContainerWidgetWithRoundedBorder({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await Clipboard.setData(ClipboardData(text: subtitle));
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("$subtitle disimpan ke Clipboard"),
          duration: Durations.medium4,
        ));
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title),
            SizedBox(
              height: 10,
            ),
            Text(
              subtitle,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
// class MyInputForm extends StatelessWidget //__
// {
//   const MyInputForm({super.key});

//   @override
//   Widget build(context) //__
//   {
//     return Column(
//       children: [
//         TextFormField(
//           decoration: InputDecoration(
//             label: const Text('Some text goes here ...'),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(10),
//             ),
//           ),
//         ).marginOnly(bottom: 10),
//         ElevatedButton(
//           onPressed: () {},
//           child: const Text('Submit'),
//         )
//       ],
//     );
//   }
// }
// class MyNestedAccordion extends StatelessWidget //__
// {
//   const MyNestedAccordion({super.key});

//   @override
//   Widget build(context) //__
//   {
//     return Accordion(
//       paddingListTop: 0,
//       paddingListBottom: 0,
//       maxOpenSections: 1,
//       headerBackgroundColorOpened: Colors.black54,
//       headerPadding: const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
//       children: [
//         AccordionSection(
//           isOpen: true,
//           leftIcon: const Icon(Icons.insights_rounded, color: Colors.white),
//           headerBackgroundColor: Colors.black38,
//           headerBackgroundColorOpened: Colors.black54,
//           header:
//               const Text('Nested Section #1', style: AccordionPage.headerStyle),
//           content: const Text(AccordionPage.loremIpsum,
//               style: AccordionPage.contentStyle),
//           contentHorizontalPadding: 20,
//           contentBorderColor: Colors.black54,
//         ),
//         AccordionSection(
//           isOpen: true,
//           leftIcon: const Icon(Icons.compare_rounded, color: Colors.white),
//           header:
//               const Text('Nested Section #2', style: AccordionPage.headerStyle),
//           headerBackgroundColor: Colors.black38,
//           headerBackgroundColorOpened: Colors.black54,
//           contentBorderColor: Colors.black54,
//           content: const Row(
//             children: [
//               Icon(Icons.compare_rounded,
//                   size: 120, color: Colors.orangeAccent),
//               Flexible(
//                   flex: 1,
//                   child: Text(AccordionPage.loremIpsum,
//                       style: AccordionPage.contentStyle)),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

// class MyDataTable extends StatelessWidget //__
// {
//   const MyDataTable({super.key});

//   @override
//   Widget build(context) //__
//   {
//     return DataTable(
//       sortAscending: true,
//       sortColumnIndex: 1,
//       showBottomBorder: false,
//       columns: const [
//         DataColumn(
//             label: Text('ID', style: AccordionPage.contentStyleHeader),
//             numeric: true),
//         DataColumn(
//             label:
//                 Text('Description', style: AccordionPage.contentStyleHeader)),
//         DataColumn(
//             label: Text('Price', style: AccordionPage.contentStyleHeader),
//             numeric: true),
//       ],
//       rows: const [
//         DataRow(
//           cells: [
//             DataCell(Text('1',
//                 style: AccordionPage.contentStyle, textAlign: TextAlign.right)),
//             DataCell(Text('Fancy Product', style: AccordionPage.contentStyle)),
//             DataCell(Text(r'$ 199.99',
//                 style: AccordionPage.contentStyle, textAlign: TextAlign.right))
//           ],
//         ),
//         DataRow(
//           cells: [
//             DataCell(Text('2',
//                 style: AccordionPage.contentStyle, textAlign: TextAlign.right)),
//             DataCell(
//                 Text('Another Product', style: AccordionPage.contentStyle)),
//             DataCell(Text(r'$ 79.00',
//                 style: AccordionPage.contentStyle, textAlign: TextAlign.right))
//           ],
//         ),
//         DataRow(
//           cells: [
//             DataCell(Text('3',
//                 style: AccordionPage.contentStyle, textAlign: TextAlign.right)),
//             DataCell(
//                 Text('Really Cool Stuff', style: AccordionPage.contentStyle)),
//             DataCell(Text(r'$ 9.99',
//                 style: AccordionPage.contentStyle, textAlign: TextAlign.right))
//           ],
//         ),
//         DataRow(
//           cells: [
//             DataCell(Text('4',
//                 style: AccordionPage.contentStyle, textAlign: TextAlign.right)),
//             DataCell(Text('Last Product goes here',
//                 style: AccordionPage.contentStyle)),
//             DataCell(Text(r'$ 19.99',
//                 style: AccordionPage.contentStyle, textAlign: TextAlign.right))
//           ],
//         ),
//       ],
//     );
//   }
// }

class Item {
  String expandedValue;
  String headerValue;
  bool isExpanded;

  Item({
    required this.expandedValue,
    required this.headerValue,
    this.isExpanded = false,
  });
}

List<Item> generateItems(int numberOfItems) {
  return List<Item>.generate(numberOfItems, (int index) {
    return Item(
      headerValue: 'Panel $index',
      expandedValue: 'This is item number $index',
    );
  });
}
