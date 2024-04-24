// ignore_for_file: non_constant_identifier_names, empty_catches

import 'package:firebase_auth/firebase_auth.dart';

class AuthMethods {
  final FirebaseAuth auth = FirebaseAuth.instance;

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
