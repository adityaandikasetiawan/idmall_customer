import 'package:flutter/material.dart';
import 'package:idmall/pages/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController emailController = TextEditingController();

  String email = "";

  final _formKey = GlobalKey<FormState>();

  void resetPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "Password Reset Email has been sent !",
          style: TextStyle(fontSize: 18.0),
        ),
      ));
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            "No user found with that email",
            style: TextStyle(fontSize: 18.0),
          ),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(top: 155.0, left: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Lupa Password",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(0.5),
                    margin: const EdgeInsets.only(right: 20.0),
                    child: Image.asset(
                      'images/signup.png',
                      height: 250,
                      width: 250,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Expanded(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15),
                  child: ListView(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 10.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: const Color.fromARGB(255, 93, 92, 92),
                              width: 2.0),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TextFormField(
                          controller: emailController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter an email';
                            }
                            if (!isValidEmail(value)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                          style: const TextStyle(
                            color: Color.fromARGB(255, 93, 92, 92),
                          ),
                          decoration: const InputDecoration(
                              hintText: "Enter Email",
                              hintStyle: TextStyle(
                                fontSize: 18.0,
                                color: Color.fromARGB(255, 93, 92, 92),
                              ),
                              prefixIcon: Icon(
                                Icons.person,
                                color: Color.fromARGB(255, 93, 92, 92),
                                size: 30.0,
                              ),
                              border: InputBorder.none),
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      const Text(
                        "We will send you a message to reset your password",
                        style: TextStyle(
                            fontSize: 10.0,
                            color: Color.fromARGB(255, 93, 92, 92)),
                      ),
                      const SizedBox(
                        height: 40.0,
                      ),
                      GestureDetector(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              email = emailController.text;
                            });
                            resetPassword();
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: 140,
                          height: 55,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 228, 99, 7),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            "Send Email",
                            style: TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 50.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don't have an account?",
                            style: TextStyle(
                                fontSize: 18.0,
                                color: Color.fromARGB(255, 93, 92, 92)),
                          ),
                          const SizedBox(
                            width: 5.0,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const SignUp()));
                            },
                            child: const Text(
                              "Sign Up",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 228, 99, 7),
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w500),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool isValidEmail(String email) {
    // Simple email validation check
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}
