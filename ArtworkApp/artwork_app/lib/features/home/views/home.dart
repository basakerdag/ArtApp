import 'package:artwork_app/features/auth/views/aboutUs/aboutUsPage.dart';
import 'package:artwork_app/features/auth/views/artists/artistsPage.dart';
import 'package:artwork_app/features/auth/views/contact/contactPage.dart';
import 'package:artwork_app/features/auth/views/doYouWant/doYouWantPage.dart';
import 'package:flutter/material.dart';
import 'package:artwork_app/features/auth/views/product/productPage.dart';
import 'package:artwork_app/features/auth/views/sign_in.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ArtworkApp'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/menu.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          color: Colors.white.withOpacity(0.8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTitle('Artwork App'),
              SizedBox(height: 20),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.all(20),
                  children: [
                    _buildListItem(context, 'Product Categories', () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProductPage()),
                      );
                    }),
                    _buildListItem(context, 'Artists', () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder:(context)=>ArtistsPage()),
                      );
                    }),
                    _buildListItem(context, 'Do you want to sell your works of art?', () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder:(context)=>DoYouWantPage()),
                      );
                    }),
                    _buildListItem(context, 'About us', () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context)=>AboutUsPage()),
                        );
                    }),
                    _buildListItem(context, 'Contact', () {
                      Navigator.push(
                        context, 
                        MaterialPageRoute(builder:(context)=>ContactPage()),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => SignIn()),
            (route) => false,
          );
        },
        child: Icon(Icons.exit_to_app),
        backgroundColor: Colors.pinkAccent, // Pembe arkaplan
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked, // Sağ alt köşeye yerleştirme
    );
  }

  Widget _buildTitle(String title) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.black,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildListItem(BuildContext context, String title, Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.white)),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: Colors.pink,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

