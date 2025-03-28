// ignore_for_file: empty_catches, no_leading_underscores_for_local_identifiers, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:idmall/pages/login.dart';
import 'package:idmall/config/config.dart' as config;
import 'package:dio/dio.dart';

class SignUp extends StatefulWidget {
  final String? existingUserFirstName;
  final String? existingUserLastName;
  final String? existingUserFullName;
  final String? existingUserEmail;
  final String? isAlreadySubscribed;

  const SignUp({
    this.existingUserFirstName,
    this.existingUserLastName,
    this.existingUserEmail,
    this.existingUserFullName,
    this.isAlreadySubscribed,
    super.key,
  });

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String email = "";
  String firstName = "";
  String lastName = "";
  String fullName = "";
  String password = "";
  String? isAlreadySubscribed = "0";

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController repeatPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _isPasswordVisible = false;

  bool _isRepeatPasswordVisible = false;
  bool isLoading = false;

  Future<void> registration() async {
    try {
      final dio = Dio();
      final response = await dio.post(
        "${config.backendBaseUrl}/user/register",
        data: {
          "first_name": firstNameController.text,
          "last_name": lastNameController.text,
          "full_name": fullNameController.text,
          "is_connected_to_oss": isAlreadySubscribed,
          "email": emailController.text,
          "password": passwordController.text,
        },
      );

      if (isAlreadySubscribed == "0") {}
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Success"),
            content: Text(response.data['message']),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Login(),
                    ),
                  );
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );

      setState(
        () {
          isLoading = false;
        },
      );
    } on DioException catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            icon: const Icon(Icons.error),
            iconColor: Colors.red,
            title: const Text("Warning"),
            content: Text(e.response?.data['errors']['message']),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
      setState(
        () {
          isLoading = false;
        },
      );
    }
  }

  @override
  void initState() {
    // firstNameController.text = widget.existingUserFirstName ?? "";
    // lastNameController.text = widget.existingUserLastName ?? "";
    fullNameController.text = widget.existingUserFullName ?? "";
    emailController.text = widget.existingUserEmail ?? "";
    if (widget.isAlreadySubscribed != null) {
      isAlreadySubscribed = widget.isAlreadySubscribed.toString();
    } else {
      isAlreadySubscribed = "0";
    }

    super.initState();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    fullNameController.dispose();
    repeatPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
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
                      child: const Column(
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
                          SizedBox(height: 0.1),
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
                    // Row(
                    //   children: [
                    //     Expanded(
                    //       child: Padding(
                    //         padding: const EdgeInsets.only(right: 10.0),
                    //         child: TextFormField(
                    //           controller: firstNameController,
                    //           validator: (value) {
                    //             if (value == null || value.isEmpty) {
                    //               return 'Please Enter First Name';
                    //             }
                    //             return null;
                    //           },
                    //           style: const TextStyle(
                    //               color: Color.fromARGB(255, 0, 0, 0)),
                    //           decoration: InputDecoration(
                    //             hintText: 'Nama Depan',
                    //             hintStyle: const TextStyle(
                    //                 color: Color.fromARGB(255, 93, 92, 92)),
                    //             border: OutlineInputBorder(
                    //               borderRadius: BorderRadius.circular(20.0),
                    //             ),
                    //             contentPadding: const EdgeInsets.symmetric(
                    //                 vertical: 15.0, horizontal: 20.0),
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //     Expanded(
                    //       child: Padding(
                    //         padding: const EdgeInsets.only(left: 10.0),
                    //         child: TextFormField(
                    //           controller: lastNameController,
                    //           style: const TextStyle(
                    //               color: Color.fromARGB(255, 0, 0, 0)),
                    //           decoration: InputDecoration(
                    //             hintText: 'Nama Belakang',
                    //             hintStyle: const TextStyle(
                    //                 color: Color.fromARGB(255, 93, 92, 92)),
                    //             border: OutlineInputBorder(
                    //               borderRadius: BorderRadius.circular(20.0),
                    //             ),
                    //             contentPadding: const EdgeInsets.symmetric(
                    //                 vertical: 15.0, horizontal: 20.0),
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    // const SizedBox(height: 20),
                    TextFormField(
                      controller: fullNameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Mohon masukkan nama';
                        }
                        return null;
                      },
                      style:
                          const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                      decoration: InputDecoration(
                        hintText: 'Nama Lengkap',
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
                    TextFormField(
                      controller: emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Mohon masukkan email';
                        } else if (!value.contains('@') ||
                            !value.contains('.')) {
                          return 'Mohon masukkan email yang valid';
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
                    TextFormField(
                      controller: passwordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Mohon masukkan password';
                        } else if (value.length < 8) {
                          return 'Panjang password minimal 8 karakter';
                        } else if (!RegExp(
                                r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#$%^&*()_+{}|:"<>?/~`]).{8,}$')
                            .hasMatch(value)) {
                          return 'Password harus dimulai dengan huruf kapital\n dan minimal terdiri dari satu huruf kecil, satu nomor\n dan satu spesial karakter';
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
                    const SizedBox(
                      height: 5,
                    ),
                    const BulletList(items: [
                      'Panjang password minimal 8 karakter',
                      'Password harus mengandung special character',
                      'Password harus mengandung angka'
                    ]),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: repeatPasswordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Mohon masukkan ulang password';
                        } else if (value != passwordController.text) {
                          return 'Password tidak cocok';
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
                            setState(
                              () {
                                _isRepeatPasswordVisible =
                                    !_isRepeatPasswordVisible;
                              },
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    isLoading == false
                        ? GestureDetector(
                            onTap: () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  email = emailController.text;
                                  firstName = firstNameController.text;
                                  lastName = lastNameController.text;
                                  password = passwordController.text;
                                  isLoading = true;
                                });
                                registration();
                              }
                            },
                            child: SizedBox(
                              height: 50.0,
                              width: 400.0,
                              child: Material(
                                color: const Color.fromARGB(255, 228, 99, 7),
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
                          )
                        : const CircularProgressIndicator(),
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

class BulletList extends StatelessWidget {
  final List<String> items;

  const BulletList({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.map((item) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Baseline(
              baseline: 20.0, // Sesuaikan dengan tinggi teks
              baselineType: TextBaseline.alphabetic,
              child: Icon(
                Icons.circle,
                size: 8,
                color: Colors.black,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Baseline(
                baseline: 20.0,
                baselineType: TextBaseline.alphabetic,
                child: Text(
                  item,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}
