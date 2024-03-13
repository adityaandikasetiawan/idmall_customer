import 'package:flutter/material.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kategori'),
      ),
      body: Center(
        child: Text(
          'Halaman Kategori',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
