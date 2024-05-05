import 'package:flutter/material.dart';

class Product1 extends StatelessWidget {
  final String productName;
  final String userUid;
  final bool isAdminButtonVisible;
  final String productId;
  final String productDescription;
  final String productArtist;
  final String imagePath;

  Product1({
    Key? key,
    required this.productName,
    required this.userUid,
    required this.isAdminButtonVisible,
    required this.productId,
    required this.productDescription,
    required this.productArtist,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product 1'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Örnek Yazı',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 50),
            if (isAdminButtonVisible)
              ElevatedButton(
                onPressed: () {
                  // Admin butonuna tıklandığında yapılacak işlemler
                },
                child: Text('Admin Button'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.white,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
