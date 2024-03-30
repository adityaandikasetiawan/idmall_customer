import 'dart:convert';
import 'package:get/get.dart';
import 'package:idmall/admin/home_admin.dart';
import 'package:idmall/guest/dashboard.dart';
import 'package:idmall/pages/navigation.dart';
import 'package:idmall/pages/forgotpassword.dart';
import 'package:idmall/pages/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:idmall/config/config.dart' as config;
import 'package:shared_preferences/shared_preferences.dart';


class Login extends StatefulWidget {
  const Login({Key? key});

  @override
  State<Login> createState() => _LoginState();
}

class LoginResponse {
  final String email;
  final String firstName;
  final String lastName;
  final String token;

  const LoginResponse(
    this.email,
    this.firstName,
    this.lastName,
    this.token,
  );

  LoginResponse.fromJson(Map<String, dynamic> json)
    : email = json['email'] as String,
      firstName = json['first_name'] as String,
      lastName = json['last_name'] as String,
      token = json['token'] as String;

  Map<String, dynamic> toJson() => {
      'email': email,
      'firstName' : firstName,
      'fullName' : firstName + ' ' + lastName,
      'lastName' : lastName,
      'token': token
  };
}

Future<dynamic> loginWithEmailPassword(payload) async{
  final body = jsonDecode(payload);

  final dio = Dio();
  final response = await dio.post('${config.backendBaseUrl}/user/login',
    data: {
      "email" : body["email"],
      "password" : body["password"],
    },
  );

  var data = response.data;
  var httpStatus = response.statusCode;
  return response;

}
class _LoginState extends State<Login> {
  User? currentUser;
  String email = "", password = "";

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController useremailcontroller = TextEditingController();
  TextEditingController userpasswordcontroller = TextEditingController();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void dispose() {
    useremailcontroller.dispose();
    userpasswordcontroller.dispose();
    super.dispose();
  }

  Future<void> userLogin() async {
    try {
      var payload = json.encode({
          "email": "${useremailcontroller.text}",
          "password": "${userpasswordcontroller.text}", 
      });

    var response = await loginWithEmailPassword(payload);
    print('cek');
    if (response.statusCode == 200) {
      var token = response.data['data']['token'];
      var fullName = response.data['data']['first_name'] + ' ' + response.data['data']['last_name'];
      var userId = response.data['data']['id'];
      var email = response.data['data']['email'];
      print(response.data);
      final SharedPreferences prefs = await _prefs;
      prefs.setString('token', token);
      prefs.setString('fullName', fullName);
      prefs.setString('firstName', response.data['data']['first_name']);
      prefs.setString('lastName', response.data['data']['last_name']);
      prefs.setString('email', email);
      prefs.setString('user_id', userId.toString());
    }
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const NavigationScreen()),
      (Route<dynamic> route) => false,
    );
  } on DioException catch (e) {
    if (e.response?.statusCode == 403) {
      showDialog(
        context: Get.context!,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Error"),
            content: Text("Email atau password salah, silakan coba lagi"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: Get.context!,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Error"),
            content: Text(e.message!),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }

    // }on DioException catch (e) {

    //   if(e.response?.statusCode == 403){
    //     showDialog(
    //       context: context,
    //       builder: (BuildContext context) {
    //         return AlertDialog(
    //           title: const Text("Error"),
    //           content: Text("Email atau password salah, silakan coba lagi"),
    //           actions: <Widget>[
    //             TextButton(
    //               onPressed: () {
    //                 Navigator.of(context).pop();
    //               },
    //               child: const Text("OK"),
    //             ),
    //           ],
    //         );
    //       },
    //     );
    //   }

    // //   String errorMessage = 'An error occurred while signing in. Please try again.';
    // //   if (e.code == 'user-not-found' || e.code == 'wrong-password') {
    // //     errorMessage = 'Email or password is incorrect. Please try again.';
    // //     // Tampilkan dialog popup
    // //     showDialog(
    // //       context: context,
    // //       builder: (BuildContext context) {
    // //         return AlertDialog(
    // //           title: const Text("Error"),
    // //           content: Text(errorMessage),
    // //           actions: <Widget>[
    // //             TextButton(
    // //               onPressed: () {
    // //                 Navigator.of(context).pop();
    // //               },
    // //               child: const Text("OK"),
    // //             ),
    // //           ],
    // //         );
    // //       },
    // //     );
    // //   }
    // }
  }
//unused
//   Future<void> userLogin() async {
//     try {
//       await FirebaseAuth.instance.signInWithEmailAndPassword(
//         email: useremailcontroller.text,
//         password: userpasswordcontroller.text,
//       );
//       User? user = FirebaseAuth.instance.currentUser;
//       print('User after login: $user');
//
//       setState(() {
//         currentUser = user;
//       });
//
//       print(currentUser?.uid);
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => const BottomNav()),
//       );
//     } on FirebaseAuthException catch (e) {
//       String errorMessage = 'An error occurred while signing in. Please try again.';
//       if (e.code == 'user-not-found' || e.code == 'wrong-password') {
//         errorMessage = 'Email or password is incorrect. Please try again.';
//         // Tampilkan dialog popup
//         showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               title: const Text("Error"),
//               content: Text(errorMessage),
//               actions: <Widget>[
//                 TextButton(
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                   child: const Text("OK"),
//                 ),
//               ],
//             );
//           },
//         );
//       }
//     }
//   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Container(
                child: Container(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 30.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Container(
                                margin:
                                    const EdgeInsets.only(top: 120.0, left: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Selamat Datang di IdMall",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
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
                      const SizedBox(height: 10),
                      Form(
                        key: _formKey,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              TextFormField(
                                controller: useremailcontroller,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please Enter Email';
                                  }
                                  return null;
                                },
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                ),
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.email, color: Color.fromARGB(255, 93, 92, 92)),
                                  hintText: 'Email',
                                  hintStyle: const TextStyle(color: Color.fromARGB(255, 93, 92, 92)),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                                ),
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                controller: userpasswordcontroller,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Tolong Masukkan Password';
                                  }
                                  return null;
                                },
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                ),
                                obscureText: true,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.lock, color: Color.fromARGB(255, 93, 92, 92)),
                                  hintText: 'Password',
                                  hintStyle: const TextStyle(color: Color.fromARGB(255, 93, 92, 92)),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                                ),
                              ),
                              const SizedBox(height: 10.0),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ForgotPassword()));
                                },
                                child: Container(
                                  alignment: Alignment.topRight,
                                  child: Text(
                                    "Lupa Password?",
                                    style: TextStyle(
                                      color: const Color.fromARGB(255, 228, 99, 7),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.0,
                                      fontFamily: 'Poppins',
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 30.0),
                              GestureDetector(
                                onTap: () async {
                                  if (_formKey.currentState!.validate()) {
                                    String enteredEmail = useremailcontroller.text;
                                    String enteredPassword = userpasswordcontroller.text;

                                    if (enteredEmail == 'admin' && enteredPassword == 'admin') {
                                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeAdmin()));
                                    } else {
                                      userLogin();
                                    }
                                  }
                                },
                                child: Material(
                                  borderRadius: BorderRadius.circular(20.0),
                                  color: Color.fromARGB(255, 228, 99, 7),
                                  child: const SizedBox(
                                    width: 400.0,
                                    height: 50.0,
                                    child: Center(
                                      child: Text(
                                        "Sign In",
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
                                    "Tidak Memiliki Akun?",
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 93, 92, 92),
                                      fontSize: 14.0,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  const SizedBox(width: 5.0),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUp()));
                                      print("Sign Up tapped!");
                                    },
                                    child: const Text(
                                      "Daftar",
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
                              const SizedBox(height: 30.0),
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: 1.0,
                                      color: Colors.grey,
                                      margin: const EdgeInsets.symmetric(horizontal: 10.0),
                                    ),
                                  ),
                                  const Text(
                                    "Atau",
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 93, 92, 92),
                                      fontSize: 20.0,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: 1.0,
                                      color: Colors.grey,
                                      margin: const EdgeInsets.symmetric(horizontal: 10.0),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 30.0),
                              OutlinedButton(
                                style: TextButton.styleFrom(
                                  fixedSize: Size(MediaQuery.of(context).size.width, 50),
                                  side: BorderSide(width: 2.0, color: Color.fromARGB(255, 228, 99, 7)),
                                ),
                                onPressed: () {
                                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const DashboardGuest()));
                                },
                                child: Text(
                                  'Log In as Guest',
                                  style: TextStyle(
                                    color: Colors.black,
                                    // color: Color.fromARGB(255, 93, 92, 92),
                                    fontSize: 16.0,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
