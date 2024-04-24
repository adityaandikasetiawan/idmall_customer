import 'package:flutter/material.dart';

class EmptyPage extends StatefulWidget {
  const EmptyPage({super.key});

  @override
  State<EmptyPage> createState() => _EmptyPageState();
}

class _EmptyPageState extends State<EmptyPage> {
  String message = "";

  @override
  void didChangeDependencies() {
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
    return const SafeArea(
      child: Scaffold(
        body: Center(
          child: Text('Push Notifications'),
        ),
      ),
    );
  }
}
