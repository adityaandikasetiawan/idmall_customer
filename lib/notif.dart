import 'package:flutter/material.dart';

class PushNotificationOnAll extends StatefulWidget {
  const PushNotificationOnAll({super.key});

  @override
  State<PushNotificationOnAll> createState() => _PushNotificationOnAllState();
}

class _PushNotificationOnAllState extends State<PushNotificationOnAll> {
  String message = "";

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    final arguments = ModalRoute.of(context)?.settings.arguments;

    if (arguments != null) {
      Map? pushArguments = arguments as Map;

      setState(() {
        message = pushArguments["message"];
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Container(
            child: Text('Push Notifications'),
          ),
        ),
      ),
    );
  }
}