// ignore_for_file: non_constant_identifier_names, empty_catches

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:idmall/config/config.dart' as config;

class AuthService extends GetxService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final dio = Dio();

  //login
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      var response = await dio.post(
        "${config.backendBaseUrlProd}/user/login",
        data: {
          'email': email,
          'password': password,
        },
      );
      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': response.data['data'],
        };
      } else {
        return {
          'success': false,
          'message': response.data['errors']['message'] ?? 'Login failed'
        };
      }
    } on DioException catch (e) {
      print(e);
      if (e.response != null) {
        return {
          'success': false,
          'message':
              e.response?.data['errors']['message'] ?? 'Server error occurred'
        };
      } else {
        return {
          'success': false,
          'message': 'Network error, please try again later'
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An unexpected error occurred',
      };
    }
  }

  getCurrentUser() async {
    return auth.currentUser;
  }

  Future<void> SignOut() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {}
  }

  Future deleteuser() async {
    User? user = FirebaseAuth.instance.currentUser;
    user?.delete();
  }

  Future<void> reauthenticateUser(String email, String currentPassword) async {
    try {
      AuthCredential credential =
          EmailAuthProvider.credential(email: email, password: currentPassword);
      await FirebaseAuth.instance.currentUser!
          .reauthenticateWithCredential(credential);
    } catch (e) {}
  }
}
