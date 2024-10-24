import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:idmall/config/config.dart' as config;

class PaymentWebview extends StatefulWidget {
  const PaymentWebview({super.key});

  @override
  State<PaymentWebview> createState() => _PaymentWebviewState();
}

class _PaymentWebviewState extends State<PaymentWebview> {
  late final WebViewController _controller;
  final dio = Dio();
  late String url = ''; // Awalnya URL kosong

  @override
  void initState() {
    super.initState();
    _fetchUrlFromApi();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (progress) {
            print("Loading progress: $progress%");
          },
          onPageStarted: (url) {
            print("Page started loading: $url");
          },
          onPageFinished: (url) {
            print("Page finished loading: $url");
          },
          onWebResourceError: (error) {
            print("Error loading page: $error");
          },
        ),
      );
    _fetchUrlFromApi();
  }

  Future<void> _fetchUrlFromApi() async {
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token') ?? "";

    try {
      final response = await dio.get(
        "${config.backendBaseUrlProd}/wv/billing/supercorridor",
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
            "Cache-Control": "no-cache",
          },
        ),
      );
      if (response.statusCode == 200 &&
          response.data['data']['payment_link'] != null) {
        setState(() {
          url = response.data['data']['payment_link'];
          _controller.loadRequest(Uri.parse(url));
        });
      } else {
        throw Exception('Invalid response from API');
      }
    } catch (e) {
      print('Error fetching URL from API: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: WebViewWidget(controller: _controller),
      ),
    );
  }
}
