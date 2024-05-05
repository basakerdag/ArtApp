import 'package:flutter/material.dart';

class Product2 extends StatelessWidget {
  Product2(String productName);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product 2'),
      ),
      body: Center(
        child: Text('Product 2 Page'),
      ),
    );
  }
}
