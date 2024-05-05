import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:artwork_app/features/auth/views/product/productDetailPage.dart';

class Photography extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Photography', style: TextStyle(color: Colors.black)),
      ),
      body: FutureBuilder(
        future: _getUserUid(), 
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return _buildProductList(snapshot.data.toString());
          }
        },
      ),
      floatingActionButton: FutureBuilder(
        future: _getUserUid(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container();
          } else {
            String userUid = snapshot.data.toString();
            if (userUid == 'XS0BdY1k6vcAyVWA1jWdljyGnoh1') {
              return FloatingActionButton(
                onPressed: () {
                  _addNewProduct(context);
                },
                child: Icon(Icons.add),
              );
            } else {
              return Container();
            }
          }
        },
      ),
    );
  }

  Widget _buildProductList(String userUid) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('photographyProduct').orderBy('productName').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        final List<Map<String, dynamic>> products = snapshot.data!.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

        return ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            final Map<String, dynamic> productData = products[index];

            final String productId = snapshot.data!.docs[index].id;
            final String productName = productData['productName'] ?? '';
            final String productDescription = productData['productDescription'] ?? '';
            final String productArtist = productData['productArtist'] ?? '';
            final String imagePath = productData['imagePath'] ?? '';

            return _buildProductPreview(
              context,
              productId,
              productName,
              productDescription,
              imagePath,
              productArtist,
              isAdminButtonVisible: userUid == 'XS0BdY1k6vcAyVWA1jWdljyGnoh1',
            );
          },
        );
      },
    );
  }

  Widget _buildProductPreview(BuildContext context, String productId, String productName, String productDescription, String imagePath, String productArtist, {required bool isAdminButtonVisible}) {
    return ListTile(
      title: Text(
        productName,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            productDescription,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          Text(
            'Artist: $productArtist',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
      leading: Container(
        width: 60,
        height: 60,
        child: CircleAvatar(
          backgroundImage: AssetImage(imagePath),
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProductDetailPage(productName:productName, productArtist: productArtist,)),
        );
      },
      trailing: isAdminButtonVisible
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Delete Product'),
                        content: Text('Are you sure you want to delete the product?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Cancel', style: TextStyle(color: Colors.white)),
                          ),
                          TextButton(
                            onPressed: () {
                              _deleteProduct(productId);
                              Navigator.pop(context);
                            },
                            child: Text('OK', style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    // Edit functionality code goes here
                  },
                ),
              ],
            )
          : null,
    );
  }

  Future<String> _getUserUid() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      return '';
    }
  }

  void _addNewProduct(BuildContext context) async {
    String productName = '';
    String productArtist = '';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add New Product', style: TextStyle(color: Colors.white)),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Product Name', labelStyle: TextStyle(color: Colors.white)),
                style: TextStyle(color: Colors.white),
                onChanged: (value) {
                  productName = value;
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Product Artist', labelStyle: TextStyle(color: Colors.white)),
                style: TextStyle(color: Colors.white),
                onChanged: (value) {
                  productArtist = value;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () {
              if (productName.isNotEmpty && productArtist.isNotEmpty) {
                _uploadProductToFirestore(productName, productArtist);
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Please enter product name and artist.', style: TextStyle(color: Colors.white)),
                ));
              }
            },
            child: Text('Add', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _uploadProductToFirestore(String productName, String productArtist) async {
    await FirebaseFirestore.instance.collection('photographyProduct').add({
      'productName': productName,
      'productArtist': productArtist,
    }).then((value) {
      print('Product added to Firestore with ID: ${value.id}');
    }).catchError((error) {
      print('Error adding product to Firestore: $error');
    });
  }

  void _deleteProduct(String productId) {
    FirebaseFirestore.instance.collection('photographyProduct').doc(productId).delete()
      .then((value) {
        print('Product deleted from Firestore with ID: $productId');
      })
      .catchError((error) {
        print('Error deleting product from Firestore: $error');
      });
  }
}

