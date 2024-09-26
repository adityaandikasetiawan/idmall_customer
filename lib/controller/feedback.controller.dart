// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:idmall/service/feedback.dart';

class FeedbackController extends GetxController {
  final FeedbackService feedbackService = Get.put(FeedbackService());

  //sales signature qr code
  TextEditingController feedback = TextEditingController();
  RxString category = "KELUHAN".obs;

  //loading parameter
  RxBool isLoading = false.obs;

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
