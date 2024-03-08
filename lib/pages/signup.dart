import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:idmall/models/signup.dart';
import 'package:idmall/pages/login.dart';
import 'package:idmall/service/database.dart';
import 'package:idmall/service/shared_preference_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:random_string/random_string.dart';
import '../widget/widget_support.dart';
import 'package:idmall/config/config.dart' as config;
import 'package:dio/dio.dart';
import 'package:idmall/pages/bottomnav.dart';


class SignUp extends StatefulWidget {
  const SignUp({Key? key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String email = "";
  String firstName = "";
  String lastName = "";
  String password = "";

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController repeatPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _isPasswordVisible = false;
  bool _isRepeatPasswordVisible = false;

  Future<Signup?> registerUser() async {
    final dio = Dio();
    final response = await dio.post("${config.backendBaseUrl}/user/register",
        data: {
          "first_name": firstNameController.text,
          "last_name": lastNameController.text,
          "email": emailController.text,
          "password": passwordController.text,
        },
    );

    if(response.statusCode == 200){
      var responseJson = jsonDecode(response.data);
      return Signup.fromJson(responseJson);
    }else{
      return null;
    }
  }

  registration() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        // await FirebaseAuth.instance.createUserWithEmailAndPassword(
        //   email: emailController.text,
        //   password: passwordController.text,
        // );

        var response  = await registerUser();

        print("return from registerUser() ${response}");

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            "Registered Successfully",
            style: TextStyle(fontSize: 20.0),
          ),
        ));

        String uid = randomAlphaNumeric(10);
        Map<String, dynamic> addUserInfo = {
          "Name": firstNameController.text + " " + lastNameController.text,
          "Email": emailController.text,
          "Wallet": "0",
          "Id": uid,
        };

        await SharedPreferenceHelper().clearAllPreferences();
        await DatabaseMethods().addUserDetail(addUserInfo, uid);
        await SharedPreferenceHelper().saveUserName(
            firstNameController.text + " " + lastNameController.text);
        await SharedPreferenceHelper().saveUserEmail(emailController.text);
        await SharedPreferenceHelper().saveUserUId(uid);
        await SharedPreferenceHelper().saveUserWallet('0');

        print('id saat daftar: ${await SharedPreferenceHelper().getIdUser()}');
        print(
            'nama saat daftar: ${await SharedPreferenceHelper().getNameUser()}');
        print(
            'email saat daftar: ${await SharedPreferenceHelper().getEmailUser()}');

        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const BottomNav()));
      } on FirebaseAuthException catch (e) {
        print('Firebase Auth Exception: $e');

        if (e.code == 'email-already-in-use') {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              "Email already exists. Please use a different email.",
              style: TextStyle(fontSize: 18.0, fontFamily: 'Poppins'),
            ),
          ));
        } else if (e.code == 'network-request-failed') {
          print('Network request failed: Check internet connection.');
        } else {
          print('Error signing up: ${e.message}');
        }
      } catch (error) {
        print('Unexpected error: $error');
      }
    }
  }

  // registration() async {
  //   if (_formKey.currentState?.validate() ?? false) {
  //     try {
  //       await FirebaseAuth.instance.createUserWithEmailAndPassword(
  //         email: emailController.text,
  //         password: passwordController.text,
  //       );
  //
  //       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //         backgroundColor: Colors.green,
  //         content: Text(
  //           "Registered Successfully",
  //           style: TextStyle(fontSize: 20.0),
  //         ),
  //       ));
  //
  //       String uid = randomAlphaNumeric(10);
  //       Map<String, dynamic> addUserInfo = {
  //         "Name": firstNameController.text + " " + lastNameController.text,
  //         "Email": emailController.text,
  //         "Wallet": "0",
  //         "Id": uid,
  //       };
  //
  //       await SharedPreferenceHelper().clearAllPreferences();
  //       await DatabaseMethods().addUserDetail(addUserInfo, uid);
  //       await SharedPreferenceHelper().saveUserName(
  //           firstNameController.text + " " + lastNameController.text);
  //       await SharedPreferenceHelper().saveUserEmail(emailController.text);
  //       await SharedPreferenceHelper().saveUserUId(uid);
  //       await SharedPreferenceHelper().saveUserWallet('0');
  //
  //       print('id saat daftar: ${await SharedPreferenceHelper().getIdUser()}');
  //       print(
  //           'nama saat daftar: ${await SharedPreferenceHelper().getNameUser()}');
  //       print(
  //           'email saat daftar: ${await SharedPreferenceHelper().getEmailUser()}');
  //
  //       Navigator.pushReplacement(context,
  //           MaterialPageRoute(builder: (context) => const BottomNav()));
  //     } on FirebaseAuthException catch (e) {
  //       print('Firebase Auth Exception: $e');
  //
  //       if (e.code == 'email-already-in-use') {
  //         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //           backgroundColor: Colors.red,
  //           content: Text(
  //             "Email already exists. Please use a different email.",
  //             style: TextStyle(fontSize: 18.0, fontFamily: 'Poppins'),
  //           ),
  //         ));
  //       } else if (e.code == 'network-request-failed') {
  //         print('Network request failed: Check internet connection.');
  //       } else {
  //         print('Error signing up: ${e.message}');
  //       }
  //     } catch (error) {
  //       print('Unexpected error: $error');
  //     }
  //   }
  // }

  @override
  void dispose() {
    firstNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    repeatPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(top: 190.0, left: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Daftar IdMall",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          const SizedBox(height: 0.1),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(0.5),
                    margin: const EdgeInsets.only(right: 20.0),
                    child: Image.asset(
                      'images/signup.png',
                      height: 200,
                      width: 200,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: TextFormField(
                              controller: firstNameController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please Enter First Name';
                                }
                                return null;
                              },
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0)),
                              decoration: InputDecoration(
                                hintText: 'Nama Depan',
                                hintStyle: const TextStyle(
                                    color: Color.fromARGB(255, 93, 92, 92)),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 15.0, horizontal: 20.0),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: TextFormField(
                              controller: lastNameController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please Enter Last Name';
                                }
                                return null;
                              },
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0)),
                              decoration: InputDecoration(
                                hintText: 'Nama Belakang',
                                hintStyle: const TextStyle(
                                    color: Color.fromARGB(255, 93, 92, 92)),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 15.0, horizontal: 20.0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter Email';
                        } else if (!value.contains('@') ||
                            !value.contains('.')) {
                          return 'Please Enter a Valid Email';
                        }
                        return null;
                      },
                      style:
                          const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                      decoration: InputDecoration(
                        hintText: 'Email',
                        hintStyle: const TextStyle(
                            color: Color.fromARGB(255, 93, 92, 92)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 20.0),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const SizedBox(height: 20),
                    // Remaining form fields...
                    // TextFormField for First Name, Last Name, Password, Repeat Password
                    TextFormField(
                      controller: passwordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter Password';
                        } else if (value.length < 8) {
                          return 'Password must be at least 8 characters long';
                        } else if (!RegExp(
                                r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#$%^&*()_+{}|:"<>?/~`]).{8,}$')
                            .hasMatch(value)) {
                          return 'Password must start with an uppercase letter and contain at least one lowercase letter, one number, and one special character';
                        }
                        return null;
                      },
                      style:
                          const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        hintStyle: const TextStyle(
                            color: Color.fromARGB(255, 93, 92, 92)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 20.0),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: const Color.fromARGB(255, 0, 0, 0),
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: repeatPasswordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter Repeat Password';
                        } else if (value != passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                      style:
                          const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                      obscureText: !_isRepeatPasswordVisible,
                      decoration: InputDecoration(
                        hintText: 'Masukkan Ulang Password',
                        hintStyle: const TextStyle(
                            color: Color.fromARGB(255, 93, 92, 92)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 20.0),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isRepeatPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: const Color.fromARGB(255, 0, 0, 0),
                          ),
                          onPressed: () {
                            setState(() {
                              _isRepeatPasswordVisible =
                                  !_isRepeatPasswordVisible;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            email = emailController.text;
                            firstName = firstNameController.text;
                            lastName = lastNameController.text;
                            password = passwordController.text;
                          });
                        }
                        registration();
                      },
                      child: SizedBox(
                        height: 50.0,
                        width: 400.0,
                        child: Material(
                          color: Color.fromARGB(255, 228, 99, 7),
                          borderRadius: BorderRadius.circular(20.0),
                          child: const Center(
                            child: Text(
                              "Daftar",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Apa anda telah memiliki akun?",
                          style: TextStyle(
                              color: Color.fromARGB(255, 93, 92, 92),
                              fontSize: 14.0,
                              fontFamily: 'Poppins'),
                        ),
                        const SizedBox(width: 5.0),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Login()));
                            print("Sign In tapped!");
                          },
                          child: const Text(
                            "Masuk",
                            style: TextStyle(
                              color: Color.fromARGB(255, 228, 99, 7),
                              fontSize: 14.0,
                              fontFamily: 'Poppins',
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
