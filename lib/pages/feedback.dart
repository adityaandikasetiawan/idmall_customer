import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:idmall/controller/feedback.controller.dart';
import 'package:dio/dio.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final FeedbackController feedbackController = Get.put(FeedbackController());

  Dio dio = Dio();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final List<String> categoryList = <String>[
    'KELUHAN',
    'SARAN',
    "PENGAJUAN",
    "REFERRAL",
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Saran & Masukkan',
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Kategori Saran",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: DropdownButtonFormField(
                    value: categoryList.first,
                    onChanged: (String? value) {
                      // This is called when the user selects an item.
                      feedbackController.updateCategory(value!);
                    },
                    items: categoryList
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                  ),
                ),
                _buildDetailItemLongField(
                  'Saran & Masukkan',
                  feedbackController.feedback.text,
                  feedbackController.updateFeedback,
                ),
                const SizedBox(height: 20),
                Center(
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        textStyle: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          feedbackController.sendFeedback();
                        }
                      },
                      child: const Text(
                        'Save',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItemLongField(
      String title, String value, Function(String) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 4),
          TextFormField(
            initialValue: value,
            maxLines: 5, // Menambahkan height lebih panjang
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Mohon masukkan $title';
              }
              return null;
            },
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
