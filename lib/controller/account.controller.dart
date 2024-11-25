// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:idmall/models/customer_detail2.dart';
import 'package:idmall/pages/login.dart';
import 'package:idmall/pages/otp_code.dart';
import 'package:idmall/pages/setting_form_change_phone.dart';
import 'package:idmall/service/account.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountController extends GetxController {
  final AccountService accountService = Get.put(AccountService());

  Rx<CustomerDetail2> customerDetail = CustomerDetail2(
      id: 0,
      customerId: "",
      customerName: "",
      customerSubName: "",
      customerSubAddress: "",
      monthlyPrice: 0,
      activationDate: "",
      eKtp: "",
      handphone: "",
      emailCustomer: "",
      zipCode: "",
      latitude: "",
      longitude: "",
      services: "",
      district: "",
      province: "",
      city: "",
      status: "",
      subProduct: "",
      productDisplayName: "",
      zipCodeDisplayName: "",
      notes: [],
      files: []).obs;

  //link account controller
  TextEditingController customerId = TextEditingController();
  TextEditingController validationType = TextEditingController();
  TextEditingController validationData = TextEditingController();

  //update email controller
  TextEditingController emailController = TextEditingController();

  //update phone number controller
  TextEditingController phoneNumberController = TextEditingController();

  //show card
  RxBool isShow = false.obs;
  RxBool isShow2 = false.obs;

  //loading parameter
  RxBool isLoading = false.obs;

  //function for fetch detail product
  Future<void> getCustomerDetail(String taskId) async {
    try {
      isLoading(true);
      var result = await accountService.searchCustomerId(taskId);
      customerDetail.value = result;
      isShow(true);
    } catch (e) {
      Get.snackbar('Error', 'Failed to get detail customer');
    } finally {
      isLoading(false);
    }
  }

  //function for linked account - changes email
  Future<void> linkAccount() async {
    try {
      isLoading(true);
      var result = await accountService.updateAccount(
        customerId.text,
        validationType.text,
        validationData.text,
        "",
      );
      if (result != null) {
        Get.snackbar(result['status'], result['message']);
      }
    } catch (e) {
      Get.snackbar("Failed", "Gagal menghubungkan account mohon hubungin CS");
    } finally {
      isLoading(false);
    }
  }

  //function for update email
  Future<void> updateEmail() async {
    try {
      isLoading(true);
      var result =
          await accountService.updateAccountData("EMAIL", emailController.text);
      if (result != null) {
        Get.snackbar(result['status'], result['message']);

        //remove all prefs
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.clear();

        emailController.clear();
        Get.offAll(Login());
        Get.deleteAll();
      }
    } catch (e) {
      Get.snackbar("Failed", "Failed to update email");
    } finally {
      isLoading(false);
    }
  }

  //request otp to server
  Future<void> requestOtp() async {
    try {
      isLoading(true);
      var result = await accountService.requestOtp(phoneNumberController.text);
      if (result != null) {
        Get.snackbar(result['status'], result['message']);
        Get.to(() => OtpScreen());
      }
      Get.to(() => OtpScreen());
    } catch (e) {
      Get.snackbar("Failed", "Failed to send otp");
    } finally {
      isLoading(false);
    }
  }

  //send validation otp
  Future<void> validationOtp(String otpNumber) async {
    try {
      isLoading(true);
      var result = await accountService.validationOtp(
        phoneNumberController.text,
        otpNumber,
      );
      Get.snackbar(result['status'], result['data']);
      phoneNumberController.clear();
      Get.to(() => FormChangePhoneNumber());
    } catch (e) {
      Get.snackbar("Failed", "OTP doesnt match");
    } finally {
      isLoading(false);
    }
  }
}
