import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DoYouWantPage extends StatelessWidget {
  final String url = 'https://www.phillips.com/buysell/sell';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Do You Want Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Do you want to continue?',
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _launchURL(context);
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                textStyle: TextStyle(fontSize: 18),
              ),
              child: Text('Yes'),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                _showThankYouDialog(context);
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                textStyle: TextStyle(fontSize: 18),
              ),
              child: Text('No'),
            ),
          ],
        ),
      ),
    );
  }

  void _launchURL(BuildContext context) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _showThankYouDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Thank You'),
          content: Text('Thank you for visiting our page =)'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
