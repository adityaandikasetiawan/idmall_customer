// ignore_for_file: empty_catches, avoid_print, use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:idmall/controller/dashboard.controller.dart';
import 'package:idmall/models/customer_by_email.dart';
import 'package:idmall/models/product_flyer.dart';
import 'package:idmall/pages/details_product.dart';
import 'package:idmall/pages/fab_testing.dart';
import 'package:idmall/pages/google_maps.dart';
import 'package:idmall/pages/notification_list.dart';
import 'package:idmall/pages/pembayaran_existing.dart';
import 'package:idmall/pages/pembayaran_testing.dart';
import 'package:idmall/pages/upgrade_downgrade_detail.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final DashboardController dashboardController =
      Get.put(DashboardController());

  final oCcy = NumberFormat("#,##0", "en_US");
  List<CustomerListByEmail> customerListEmails = [];

  final TextEditingController _keyword = TextEditingController();

  @override
  void initState() {
    super.initState();
    // dashboardController.fetchDashboardData();
    // dashboardController.fetchTaskIdByEmail();
  }

  Future<void> fetchRefreshData() async {
    await dashboardController.fetchDashboardData();
    await dashboardController.fetchTaskIdByEmail();
    await dashboardController.fetchProductBisnis();
    await dashboardController.fetchProductHome();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              Icons.account_circle,
              color: Colors.white,
              size: 40,
            ),
            SizedBox(
              width: 10,
            ),
            GestureDetector(
              onTap: () {
                showModalBottomSheet<void>(
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(15.0),
                    ),
                  ),
                  useSafeArea: true,
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                      padding: const EdgeInsets.all(15),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 1.5,
                      child: ListView(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "PROFIL ANDA",
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 15),
                          ListTile(
                            onTap: () {
                              // Tindakan saat bagian pertama ditekan
                            },
                            leading: const Icon(Icons.account_circle),
                            title: Text(dashboardController
                                .dashboardData.value.customerName),
                            subtitle: Text(
                                "${dashboardController.dashboardData.value.taskId} - ${dashboardController.dashboardData.value.status}"),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            "Nomor pelanggan yang Anda kelola",
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          ListTile(
                            onTap: () {
                              // Tindakan saat bagian pertama ditekan
                            },
                            leading: const Icon(Icons.home),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(dashboardController
                                    .dashboardData.value.taskId),
                                const Row(
                                  children: [
                                    Text(
                                      "Aktif",
                                      style: TextStyle(color: Colors.orange),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: 15,
                                      color: Colors.orange,
                                    )
                                  ],
                                )
                              ],
                            ),
                            subtitle: Text(
                              dashboardController
                                  .dashboardData.value.customerName,
                            ),
                          ),
                          const Divider(),
                          SizedBox(
                            height: 40,
                            child: Container(
                              height: 10,
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: TextField(
                                controller: _keyword,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(
                                    Icons.search_rounded,
                                  ),
                                  suffixIcon: IconButton(
                                    icon: const Icon(
                                      Icons.clear_rounded,
                                    ),
                                    onPressed: () => {
                                      setState(
                                        () {
                                          _keyword.clear();
                                          dashboardController
                                              .filterContractList(
                                                  _keyword.text);
                                        },
                                      )
                                    },
                                  ),
                                  hintText: 'Pencarian...',
                                  border: InputBorder.none,
                                ),
                                onChanged: (text) {
                                  setState(
                                    () {
                                      dashboardController
                                          .filterContractList(text);
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height,
                            child: ListView.builder(
                              itemCount: dashboardController
                                  .filteredCustomerIdList.length,
                              itemBuilder: (context, index) {
                                CustomerListByEmail customerList =
                                    dashboardController
                                        .filteredCustomerIdList[index];
                                return ListTile(
                                  onTap: () async {
                                    dashboardController
                                        .updateToken(customerList.customerId);
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text("Success"),
                                          content: Text(
                                              "Berhasil pindah ke CID ${customerList.customerId}"),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                Get.back();
                                              },
                                              child: const Text("OK"),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  leading: const Icon(Icons.home),
                                  title: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(customerList.customerId),
                                    ],
                                  ),
                                  subtitle: Text(
                                    "${customerList.name} - ${customerList.status}",
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(
                    () {
                      if (dashboardController.isLoading.value) {
                        return Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.grey.shade100,
                          child: Container(
                            width: 100.0,
                            height: 5.0,
                            color: Colors.grey[300],
                          ),
                        );
                      } else {
                        return Row(
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: dashboardController
                                        .dashboardData.value.customerName,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontFamily: "Inter",
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.white,
                            ),
                          ],
                        );
                      }
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Obx(
                    () {
                      if (dashboardController.isLoading.value) {
                        return Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.grey.shade100,
                          child: Container(
                            width: 50.0,
                            height: 5.0,
                            color: Colors.grey[300],
                          ),
                        );
                      } else {
                        return Text(
                          "${dashboardController.dashboardData.value.points} pts",
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: "Inter",
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                Color(0xFFFFC107),
                Color(0xFFFFA000),
              ],
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.mail_outline,
              color: Colors.white,
              size: 20,
            ),
            onPressed: () {
              Get.to(
                () => NotificationList(),
              );
            },
          ),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 250, 250, 255),
      body: RefreshIndicator(
        onRefresh: fetchRefreshData,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.only(
              top: 10.0,
              left: 20.0,
              right: 20.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () {
                    if (dashboardController.isLoading.value) {
                      if (["ACTIVE", "DU", "FREEZE"].contains(
                          dashboardController.dashboardData.value.status)) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Shimmer.fromColors(
                              baseColor: Colors.grey.shade300,
                              highlightColor: Colors.grey.shade100,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.grey[300],
                                ),
                                width: 170,
                                height: 150,
                              ),
                            ),
                            Shimmer.fromColors(
                              baseColor: Colors.grey.shade300,
                              highlightColor: Colors.grey.shade100,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.grey[300],
                                ),
                                width: 170,
                                height: 150,
                              ),
                            ),
                          ],
                        );
                      } else {
                        return SizedBox.shrink();
                      }
                    } else {
                      if (["ACTIVE", "DU", "FREEZE"].contains(
                          dashboardController.dashboardData.value.status)) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          PaymentMethodExisting(
                                        taskid: dashboardController
                                            .dashboardData.value.taskId,
                                        billStatus: dashboardController
                                            .dashboardData.value.billStatus,
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    image: const DecorationImage(
                                      image: AssetImage(
                                          'images/background_card.png'),
                                      fit: BoxFit.cover,
                                    ),
                                    border: Border.all(
                                      color: Colors.grey.withOpacity(0.5),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.all(16.0),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                "Tagihan Internet",
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            Icon(
                                              Icons.check_circle,
                                              color: Colors.green,
                                            ),
                                          ],
                                        ),
                                      ),
                                      dashboardController.dashboardData.value
                                                  .billStatus ==
                                              'Tagihan'
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5.0),
                                              child: Text(
                                                "Bayar tagihan Anda sebelum ${DateFormat('dd MMMM yyyy').format(DateTime.tryParse(dashboardController.dashboardData.value.dueDate)!)}",
                                                style: const TextStyle(
                                                  fontFamily: "Roboto",
                                                  fontSize: 8,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            )
                                          : const Text(""),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        child: Text(
                                          "Rp ${oCcy.format(dashboardController.dashboardData.value.arRemain).replaceAll(",", ".")}",
                                          style: const TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      const Divider(height: 1),
                                      const SizedBox(height: 8),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              dashboardController.dashboardData
                                                  .value.billStatus,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black54,
                                              ),
                                            ),
                                            Text(
                                              DateFormat('MMM, yyyy').format(
                                                  DateTime.tryParse(
                                                      dashboardController
                                                          .dashboardData
                                                          .value
                                                          .dueDate)!),
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  image: const DecorationImage(
                                    image: AssetImage(
                                        'images/background_card.png'),
                                    fit: BoxFit.cover,
                                  ),
                                  border: Border.all(
                                    color: Colors.grey.withOpacity(0.5),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(16.0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              "Penggunaan Bulan Ini",
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Icon(
                                            Icons.wifi,
                                            color: Colors.red,
                                          ),
                                        ],
                                      ),
                                    ),
                                    dashboardController.dashboardData.value
                                                .billStatus ==
                                            'Tagihan'
                                        ? const Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 5.0),
                                            child: Text(""),
                                          )
                                        : const Text(""),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      child: RichText(
                                        text: TextSpan(
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          children: [
                                            TextSpan(
                                                text: dashboardController
                                                    .dashboardData.value.gbIn
                                                    .toString()),
                                            WidgetSpan(
                                              child: Transform.translate(
                                                offset: const Offset(2, -12),
                                                child: const Text(
                                                  'GB',
                                                  textScaleFactor: 0.8,
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    const Divider(height: 1),
                                    const SizedBox(height: 8),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      child: Text(
                                        dashboardController
                                            .dashboardData.value.productName,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      } else {
                        return SizedBox.shrink();
                      }
                    }
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                Obx(
                  () {
                    if ([
                      "QUOTATION",
                      "PENDING_PAYMENT",
                      "PENDING_PAYMENT_MOBILE"
                    ].contains(
                        dashboardController.dashboardData.value.status)) {
                      return GestureDetector(
                        onTap: () {
                          if (dashboardController.dashboardData.value.status ==
                              "QUOTATION") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FABTesting(
                                    taskID: dashboardController
                                        .dashboardData.value.taskId),
                              ),
                            );
                          } else if (dashboardController
                                      .dashboardData.value.status ==
                                  "PENDING_PAYMENT_MOBILE" ||
                              dashboardController.dashboardData.value.status ==
                                  "PENDING_PAYMENT") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PaymentMethod(
                                  taskid: dashboardController
                                      .dashboardData.value.taskId,
                                ),
                              ),
                            );
                          }
                        },
                        child: SizedBox(
                          width: double.infinity * 2,
                          child: Card(
                            elevation: 4.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                image: const DecorationImage(
                                  image: AssetImage(
                                    'images/bb_green_mint.jpg',
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    dashboardController
                                                .dashboardData.value.status ==
                                            "QUOTATION"
                                        ? const Text(
                                            "Registrasi Anda sudah disetujui, mohon isi FORM AKTIVASI BERLANGGANAN",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        : const Text(
                                            "Registrasi Anda mencapai tahap pembayaran, silahkan melanjutkan ke proses pembayaran",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    } else {
                      return SizedBox.shrink();
                    }
                  },
                ),
                // New Promotion Card
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Card(
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    color: const Color.fromARGB(255, 19, 24, 84),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20.0),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UpgradeDowngradeDetail(
                              task: dashboardController
                                  .dashboardData.value.taskId,
                              sid: '',
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Row(
                          children: [
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Upgrade',
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 10.0),
                                  Text(
                                    'Learn More',
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 228, 99, 7),
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20.0),
                                child: Image.asset(
                                  'images/card2.png',
                                  fit: BoxFit.cover,
                                  width: 150.0,
                                  height: 150.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // New Card
                Container(
                  margin: const EdgeInsets.only(bottom: 20.0),
                  child: InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Penggunaan Lokasi"),
                            content: const Text(
                              "Idmall mengumpulkan data terkait lokasi pengguna untuk mengidentifikasi ketersediaan layanan kami dengan lokasi pengguna",
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text("Tolak"),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const MapSample(),
                                    ),
                                  );
                                },
                                child: const Text("Terima"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Card(
                      elevation: 4.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      color: const Color.fromARGB(
                        255,
                        19,
                        24,
                        84,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Row(
                          children: [
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Check Coverage',
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors
                                          .white, // Ubah warna teks menjadi putih
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Image.asset(
                                'images/coverange.png', // Perhatikan penulisan nama gambar
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Obx(
                  () {
                    if (dashboardController.isLoading.value) {
                      return Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 100.0,
                          color: Colors.grey[300],
                        ),
                      );
                    } else {
                      return Card(
                        color: Color.fromARGB(
                          1,
                          217,
                          217,
                          217,
                        ).withOpacity(0.2),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "IDPLAY HOME",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                  fontFamily: "Inter",
                                ),
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount:
                                    dashboardController.productHome.length,
                                itemBuilder: (context, index) {
                                  ProductFlyer productHome =
                                      dashboardController.productHome[index];
                                  return InternetSpeedCard(
                                    id: productHome.id.toString(),
                                    speed: productHome.speed,
                                    price: productHome.price,
                                    packageName: productHome.name,
                                  );
                                },
                              ),
                              SizedBox(
                                height: 8,
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  },
                ),

                SizedBox(
                  height: 20,
                ),

                Obx(
                  () {
                    if (dashboardController.isLoading.value) {
                      return Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 100.0,
                          color: Colors.grey[300],
                        ),
                      );
                    } else {
                      return Card(
                        color: Color.fromARGB(
                          1,
                          217,
                          217,
                          217,
                        ).withOpacity(0.2),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "IDPLAY BISNIS",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                  fontFamily: "Inter",
                                ),
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount:
                                    dashboardController.productBisnis.length,
                                itemBuilder: (context, index) {
                                  ProductFlyer productBisnis =
                                      dashboardController.productBisnis[index];
                                  return InternetSpeedCard(
                                    id: productBisnis.id.toString(),
                                    speed: productBisnis.speed,
                                    price: productBisnis.price,
                                    packageName: productBisnis.name,
                                  );
                                },
                              ),
                              SizedBox(
                                height: 8,
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class InternetSpeedCard extends StatelessWidget {
  final String id;
  final int speed;
  final int price;
  final String packageName;

  const InternetSpeedCard({
    super.key,
    required this.id,
    required this.speed,
    required this.price,
    required this.packageName,
  });

  @override
  Widget build(BuildContext context) {
    final oCcy = NumberFormat("#,##0", "en_US");

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white, // Warna latar belakang ListTile
        borderRadius: BorderRadius.circular(12), // Membuat border melengkung
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // Posisi bayangan
          ),
        ],
      ),
      child: ListTile(
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('$speed Mbps', style: TextStyle(color: Colors.red)),
                  Text(
                    "Rp. ${oCcy.format(price).replaceAll(",", ".")}",
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(packageName),
                  SizedBox(width: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.red, // Warna latar belakang tombol
                    ),
                    onPressed: () {
                      Get.to(
                        () => DetailPage(
                          ids: id,
                          isGuest: 0,
                        ),
                      );
                    },
                    child: Text(
                      'Beli',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
