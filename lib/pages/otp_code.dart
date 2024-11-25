import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:idmall/controller/account.controller.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final AccountController accountController = Get.put(AccountController());
  final List<TextEditingController> _controllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  late Timer _timer;
  int _remainingSeconds = 120;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _timer.cancel();
        }
      });
    });
  }

  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return "$minutes:$secs";
  }

  void _clearCode() {
    for (int i = 0; i < _controllers.length; i++) {
      _controllers[i].clear();
    }
  }

  void _pasteCode(String pastedCode) {
    for (int i = 0; i < _controllers.length; i++) {
      if (i < pastedCode.length) {
        _controllers[i].clear();
        _controllers[i].text = pastedCode[i];
      } else {
        _controllers[i].clear();
      }
    }
  }

  void _resendOtp() {
    Get.snackbar('Info', 'Kode OTP telah dikirim ulang.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Masukkan Kode OTP'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onTap: () async {
                final clipboardData = await Clipboard.getData('text/plain');
                if (clipboardData != null && clipboardData.text != null) {
                  _pasteCode(clipboardData.text!);
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: 50,
                    child: TextFormField(
                      controller: _controllers[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      decoration: const InputDecoration(
                        counterText: '',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty && index < 5) {
                          FocusScope.of(context).nextFocus();
                        }
                      },
                    ),
                  );
                }),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: 50,
              child: ElevatedButton(
                onPressed: () async {
                  final clipboardData = await Clipboard.getData('text/plain');
                  if (clipboardData != null && clipboardData.text != null) {
                    _pasteCode(clipboardData.text!);
                  }
                },
                child: Text('Paste OTP'),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Text(
                'Time remaining: ${_formatTime(_remainingSeconds)}',
                style: TextStyle(fontSize: 16, color: Colors.red),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () async {
                final clipboardData = await Clipboard.getData('text/plain');
                if (clipboardData != null && clipboardData.text != null) {
                  accountController.validationOtp(clipboardData.text!);
                }
              },
              child: const Text('Kirim OTP'),
            ),
          ],
        ),
      ),
    );
  }
}
