import 'package:idmall/admin/home_admin.dart';
import 'package:idmall/pages/bottomnav.dart';
import 'package:idmall/pages/forgotpassword.dart';
import 'package:idmall/pages/signup.dart';
import 'package:idmall/widget/widget_support.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  void dispose() {
    useremailcontroller.dispose();
    userpasswordcontroller.dispose();

    super.dispose();
  }

  User? currentUser;
  String email = "", password = "";

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  TextEditingController useremailcontroller = TextEditingController();
  TextEditingController userpasswordcontroller = TextEditingController();

  userLogin() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: useremailcontroller.text,
        password: userpasswordcontroller.text,
      );
      User? user = FirebaseAuth.instance.currentUser;
      print('User after login: $user');

      setState(() {
        currentUser = user;
      });

      print(currentUser?.uid);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const BottomNav()));
    } on FirebaseAuthException {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'An error occurred while signing in. Please try again.',
            style: TextStyle(fontSize: 18.0, color: Colors.white),
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
  }

  bool _isPasswordVisible = false;

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
                        padding: const EdgeInsets.only(top: 50.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Container(
                                margin:
                                    const EdgeInsets.only(top: 155.0, left: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Selamat Datang di IdMall",
                                      style: TextStyle(
                                        color: Colors
                                            .black, // Ubah warna teks menjadi hitam
                                        fontWeight: FontWeight
                                            .bold, // Tambahkan gaya teks bold
                                        fontSize:
                                            20.0, // Sesuaikan ukuran font jika diperlukan
                                        fontFamily:
                                            'Poppins', // Sesuaikan jenis font jika diperlukan
                                      ),
                                    ),
                                    const SizedBox(
                                        height:
                                            20), // Padding tambahan di bagian bawah judul
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(0.5),
                              margin: const EdgeInsets.only(
                                  right: 20.0), // Geser ke kanan sebesar 10px
                              child: Image.asset(
                                'images/signup.png', // Ganti dengan path gambar yang sesuai
                                height: 250,
                                width: 250,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      Form(
                        key: _formkey,
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
                                    color: Color.fromARGB(255, 0, 0, 0)),
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.email,
                                      color: Color.fromARGB(255, 93, 92, 92)),
                                  // Email icon
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
                                controller: userpasswordcontroller,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Tolong Masukkan Password';
                                  }
                                  return null;
                                },
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0)),
                                obscureText: !_isPasswordVisible,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.lock,
                                      color: Color.fromARGB(255, 93, 92, 92)),
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
                                      color:
                                          const Color.fromARGB(255, 93, 92, 92),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isPasswordVisible =
                                            !_isPasswordVisible;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const ForgotPassword()));
                                },
                                child: Container(
                                  alignment: Alignment.topRight,
                                  child: Text(
                                    "Lupa Password?",
                                    style: TextStyle(
                                      color: const Color.fromARGB(255, 228, 99, 7), // Ubah warna teks menjadi hitam
                                      fontWeight: FontWeight
                                          .bold, // Sesuaikan gaya teks jika diperlukan
                                      fontSize:
                                          14.0, // Sesuaikan ukuran font jika diperlukan
                                      fontFamily:
                                          'Poppins', // Sesuaikan jenis font jika diperlukan
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 30.0,
                              ),
                              GestureDetector(
                                onTap: () async {
                                  if (_formkey.currentState!.validate()) {
                                    String enteredEmail =
                                        useremailcontroller.text;
                                    String enteredPassword =
                                        userpasswordcontroller.text;

                                    if (enteredEmail == 'admin' &&
                                        enteredPassword == 'admin') {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const HomeAdmin(),
                                        ),
                                      );
                                    } else {
                                      setState(() {
                                        email = enteredEmail;
                                        password = enteredPassword;
                                      });

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
                              const SizedBox(height: 30.0),
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: 1.0,
                                      color: Colors.grey,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                    ),
                                  ),
                                  const Text(
                                    "Atau",
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 93, 92, 92),
                                        fontSize: 20.0,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: 1.0,
                                      color: Colors.grey,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 40.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Tidak Memiliki Akun?",
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
                                              builder: (context) =>
                                                  const SignUp()));
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
