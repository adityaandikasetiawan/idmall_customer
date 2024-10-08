// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:idmall/models/customer_by_email.dart';
import 'package:idmall/models/dashboard.dart';
import 'package:idmall/models/product_flyer.dart';
import 'package:idmall/pages/navigation.dart';
import 'package:idmall/service/dashboard.dart';
import 'package:idmall/service/feedback.dart';

class DashboardController extends GetxController {
  final FeedbackService feedbackService = Get.put(FeedbackService());
  final DashboardService dashboardService = Get.put(DashboardService());

  //sales signature qr code
  TextEditingController feedback = TextEditingController();
  RxString category = "KELUHAN".obs;

  //dashboard response
  Rx<DashboardModel> dashboardData = DashboardModel(
    taskId: "",
    customerName: "",
    productCode: "",
    productName: "",
    status: "",
    billStatus: "",
    dueDate: "",
    invDate: "",
    totalPayment: 0,
    arRemain: 0,
    arPaid: 0,
    period: "",
    points: 0,
    gbIn: 0,
  ).obs;

  //customer list by email
  RxList<CustomerListByEmail> customerIdList = <CustomerListByEmail>[].obs;
  RxList<CustomerListByEmail> filteredCustomerIdList =
      <CustomerListByEmail>[].obs;

  //product retail and bisnis
  RxList<ProductFlyer> productHome = <ProductFlyer>[].obs;
  RxList<ProductFlyer> productBisnis = <ProductFlyer>[].obs;

  //loading parameter
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    fetchDashboardData();
    fetchTaskIdByEmail();
    fetchProductBisnis();
    fetchProductHome();
    super.onInit();
  }

  //function for fetch dashboard data
  Future<void> fetchDashboardData() async {
    try {
      isLoading(true);
      var result = await dashboardService.getDashboardData();
      if (result != null) {
        dashboardData.value = result;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to get data');
    } finally {
      isLoading(false);
    }
  }

  //function for get taskid by email
  Future<void> fetchTaskIdByEmail() async {
    try {
      isLoading(true);
      var result = await dashboardService.getTaskIdByEmail();
      customerIdList.value = result;
      filteredCustomerIdList.assignAll(customerIdList);
    } catch (e) {
      Get.snackbar('Error', 'Failed to get cid list by email');
    } finally {
      isLoading(false);
    }
  }

  //function filter for search by taskid or name
  void filterContractList(String keyword) {
    if (keyword.isEmpty) {
      filteredCustomerIdList.assignAll(customerIdList);
    } else {
      filteredCustomerIdList.value = customerIdList
          .where(
            (task) =>
                task.name.toLowerCase().contains(keyword.toLowerCase()) ||
                task.customerId.toLowerCase().contains(keyword.toLowerCase()),
          )
          .toList();
    }
  }

  //function for update token
  Future<void> updateToken(String taskid) async {
    try {
      isLoading(true);
      var result = await dashboardService.getUpdatedToken(taskid);
      dashboardData.value = result;
      Get.snackbar('Success', 'Change CID Succesfull');
      Get.to(
        () => NavigationScreen(
          customerID: dashboardData.value.taskId,
          status: dashboardData.value.status,
        ),
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to get data');
    } finally {
      isLoading(false);
    }
  }

  //send feedback to service feedback
  Future<void> sendFeedback() async {
    try {
      isLoading(true);
      var detail =
          await feedbackService.insertFeedback(category.value, feedback.text);
      if (detail['status'] == 'success') {
        Get.snackbar('Success', 'Berhasil menyimpan kritik & saran');
        feedback.clear();
        category.value = "KELUHAN";
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to save feedback');
    } finally {
      isLoading(false);
    }
  }

  //function for get product home
  Future<void> fetchProductHome() async {
    try {
      isLoading(true);
      var result = await dashboardService.getProductHome("RETAIL");
      productHome.value = result;
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch product home');
    } finally {
      isLoading(false);
    }
  }

  //function for get product bisnis
  Future<void> fetchProductBisnis() async {
    try {
      isLoading(true);
      var result = await dashboardService.getProductBisnis("BISNIS");
      productBisnis.value = result;
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch product bisnis');
    } finally {
      isLoading(false);
    }
  }

  //update all values
  void updateCategory(String value) => category.value = value;
  void updateFeedback(String value) => feedback.text = value;
}
