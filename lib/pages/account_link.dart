import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:idmall/controller/account.controller.dart';

class AccountLink extends StatefulWidget {
  const AccountLink({super.key});

  @override
  State<AccountLink> createState() => _AccountLinkState();
}

class _AccountLinkState extends State<AccountLink> {
  final AccountController accountController = Get.put(AccountController());

  final List<String> categoryList = <String>[
    'KTP',
    'Email',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Link Account"),
        backgroundColor: Colors.amber,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 200,
                  child: TextFormField(
                    controller: accountController.customerId,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Mohon masukkan CID';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      accountController.customerId.text = value;
                    },
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    accountController
                        .getCustomerDetail(accountController.customerId.text);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange[300],
                  ),
                  child: Text("Search"),
                ),
              ],
            ),
            Obx(
              () {
                if (accountController.isShow.value) {
                  return Card(
                    // color: Colors.white,
                    child: Column(
                      children: [
                        ListTile(
                          title: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Expanded(
                                    child: Text(
                                      "Name",
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      accountController
                                          .customerDetail.value.customerSubName,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Expanded(
                                    child: Text(
                                      "Paket",
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      accountController
                                          .customerDetail.value.subProduct,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Expanded(
                                    child: Text(
                                      "Alamat",
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      accountController.customerDetail.value
                                          .customerSubAddress,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Expanded(
                                    child: Text(
                                      "Status",
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      accountController
                                          .customerDetail.value.status,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                } else {
                  return SizedBox();
                }
              },
            ),
            Obx(
              () {
                if (accountController.isShow.value) {
                  return Center(
                    child: ElevatedButton(
                      onPressed: () {
                        accountController.isShow2.value = true;
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber[300],
                      ),
                      child: Text("Hubungkan Akun"),
                    ),
                  );
                } else {
                  return SizedBox();
                }
              },
            ),
            Obx(
              () {
                if (accountController.isShow2.value) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Validasi Tipe"),
                          SizedBox(
                            height: 5,
                          ),
                          DropdownButtonFormField(
                            value: categoryList.first,
                            onChanged: (value) {
                              accountController.validationType.text = value!;
                            },
                            items: categoryList
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          const Text("Validasi Data"),
                          SizedBox(
                            height: 5,
                          ),
                          TextFormField(
                            controller: accountController.validationData,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Mohon masukkan validasi data';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              accountController.validationData.text = value;
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                accountController.linkAccount();
                              },
                              child: const Text("Submit"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return SizedBox();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
