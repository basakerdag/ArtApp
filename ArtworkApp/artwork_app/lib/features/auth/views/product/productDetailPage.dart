import 'package:flutter/material.dart';

class ProductDetailPage extends StatelessWidget {
  final String productName;
  final String productArtist;

  ProductDetailPage({
    required this.productName,
    required this.productArtist,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$productName ($productArtist)'),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(16.0),
          color: Colors.green,
          child: Text(
            'Product descriptions and square code information will be added here.',
            style: TextStyle(color: Colors.white, fontSize: 18.0),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
