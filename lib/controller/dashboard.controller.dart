// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:idmall/models/dashboard.dart';
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

  //loading parameter
  RxBool isLoading = false.obs;

  //fetch dashboard data
  Future<void> fetchDashboardData() async {
    try {
      isLoading(true);
    } catch (e) {
      Get.snackbar('Error', 'Gagal load data dashboard');
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

  //update all values
  void updateCategory(String value) => category.value = value;
  void updateFeedback(String value) => feedback.text = value;
}
