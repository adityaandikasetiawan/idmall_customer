import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:idmall/pages/navigation.dart';
import 'package:idmall/service/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  final AuthService authService = Get.put(AuthService());

  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  //loading parameter
  var isLoading = false.obs;

  //login function
  void login() async {
    try {
      isLoading.value = true;

      String email = emailController.text.trim();
      String password = passwordController.text.trim();

      var result = await authService.login(email, password);
      if (result['success']) {
        saveUserData(result['data']);

        Get.snackbar("Success", "Login successful");
        Get.to(
          () => NavigationScreen(
            customerID: result['data']['task_id'],
            status: result['data']['subscription_status'],
          ),
        );
      } else {
        showErrorDialog("Error", result['message']);
      }
    } catch (e) {
      showErrorDialog("Error", "An unexpected error occurred");
    } finally {
      isLoading.value = false;
    }
  }

  void showErrorDialog(String title, String message) {
    Get.defaultDialog(
      title: title,
      content: Text(message),
      confirm: ElevatedButton(
        onPressed: () {
          Get.back();
        },
        child: Text("OK"),
      ),
    );
  }

  Future<void> saveUserData(Map<String, dynamic> userData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('user_id', userData['id']);
    await prefs.setString('email', userData['email']);
    await prefs.setString('fullName', userData['full_name']);
    await prefs.setString('token', userData['token']);
    await prefs.setString("taskId", userData['task_id']);
  }
}
