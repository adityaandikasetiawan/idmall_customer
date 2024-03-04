import 'package:flutter/material.dart';

class PromotionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Promotions'),
      ),
      body: Center(
        child: Text(
          'This is the Promotions Page',
          style: TextStyle(fontSize: 24.0),
        ),
      ),
    );
  }
}
