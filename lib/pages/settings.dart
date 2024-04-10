import 'package:flutter/material.dart';
import 'package:idmall/pages/setting_form_change_password.dart';
import 'package:idmall/pages/setting_form_account_information.dart';

class SettingChangePasswordPage extends StatefulWidget {
  const SettingChangePasswordPage({Key? key}) : super(key: key);
  @override
  _SettingChangePasswordPageState createState() => _SettingChangePasswordPageState();
}

class _SettingChangePasswordPageState extends State<SettingChangePasswordPage>{

  @override
  void initState(){}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.search),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Akun',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              // const SizedBox(height: 15),
              // ListTile(
              //   leading: Container(
              //     width: 50,
              //     height: 50,
              //     decoration: BoxDecoration(
              //       shape: BoxShape.circle,
              //       border: Border.all(color: Colors.grey, width: 1),
              //     ),
              //     child: const Icon(Icons.info),
              //   ),
              //   title: const Text('Informasi Akun'),
              //   trailing:
              //   const Icon(Icons.arrow_forward_ios), // Icon panah ke kanan
              //   onTap: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) => const FormAccountInformation()),
              //       );
              //   },
              // ),
              const SizedBox(height: 15),
              ListTile(
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey, width: 1),
                  ),
                  child: const Icon(Icons.key),
                ),
                title: const Text('Ubah Password'),
                trailing:
                const Icon(Icons.arrow_forward_ios), // Icon panah ke kanan
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FormChangePassword()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
