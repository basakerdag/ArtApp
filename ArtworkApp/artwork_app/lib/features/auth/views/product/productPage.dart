import 'package:flutter/material.dart';
import 'package:artwork_app/features/auth/views/product/Drawings/drawings.dart';
import 'package:artwork_app/features/auth/views/product/Photography/photography.dart';
import 'package:artwork_app/features/auth/views/product/Sculpture/sculpture.dart';
import 'package:artwork_app/features/auth/views/product/Paintings/paintings.dart';

class ProductPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Options'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/menu.jpg'), // Arka plan fotoğrafı
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildOption(context, 'Paintings', Paintings()),
              SizedBox(height: 10),
              _buildOption(context, 'Photography', Photography()),
              SizedBox(height: 10),
              _buildOption(context, 'Drawings', Drawings()),
              SizedBox(height: 10),
              _buildOption(context, 'Sculpture', Sculpture()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOption(BuildContext context, String option, Widget page) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.7), // Arkaplan rengi beyaz ve opak
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            option,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black, // Yazı rengi siyah
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ProductPage(),
  ));
}
