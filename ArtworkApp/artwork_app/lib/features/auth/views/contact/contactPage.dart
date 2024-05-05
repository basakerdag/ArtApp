import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ContactPage extends StatefulWidget {
  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final String currentUserUid = FirebaseAuth.instance.currentUser?.uid ?? '';

  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController addressController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    addressController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact Us'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Contact Information',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20),
            if (currentUserUid == 'XS0BdY1k6vcAyVWA1jWdljyGnoh1')
              ElevatedButton(
                onPressed: () {
                  _showAddContactDialog(context);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Color.fromRGBO(223, 220, 220, 1)),
                child: Text('+ Add Contact', style: TextStyle(color: Colors.white)),
              ),
            SizedBox(height: 20),
            _buildContactList(),
          ],
        ),
      ),
    );
  }

  Widget _buildContactList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('contact').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.red));
        }
        final data = snapshot.data?.docs ?? [];
        return ListView.builder(
          shrinkWrap: true,
          itemCount: data.length,
          itemBuilder: (context, index) {
            final contactData = data[index].data() as Map<String, dynamic>;
            final email = contactData['email'] ?? '';
            final phone = contactData['phone'] ?? '';
            final address = contactData['address'] ?? '';
            final contactUid = data[index].id;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildContactItem(Icons.email, email),
                _buildContactItem(Icons.phone, phone),
                _buildContactItem(Icons.location_on, address),
                if (currentUserUid == 'XS0BdY1k6vcAyVWA1jWdljyGnoh1')
                  SizedBox(height: 16),
                if (currentUserUid == 'XS0BdY1k6vcAyVWA1jWdljyGnoh1')
                  ElevatedButton(
                    onPressed: () {
                      _deleteContact(contactUid, context);
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                    child: Text('Delete Contact', style: TextStyle(color: Colors.white)),
                  ),
                SizedBox(height: 16),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildContactItem(IconData iconData, String text) {
    return ListTile(
      leading: Icon(iconData, color: const Color.fromARGB(255, 230, 223, 223)),
      title: Text(text, style: TextStyle(color: Color.fromRGBO(233, 230, 230, 1))),
    );
  }

  void _showAddContactDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Contact', style: TextStyle(color: const Color.fromARGB(255, 239, 234, 234))),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: emailController,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(labelText: 'Email', labelStyle: TextStyle(color: Colors.black)),
              ),
              TextField(
                controller: phoneController,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(labelText: 'Phone', labelStyle: TextStyle(color: Colors.black)),
              ),
              TextField(
                controller: addressController,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(labelText: 'Address', labelStyle: TextStyle(color: Colors.black)),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel', style: TextStyle(color: Colors.black)),
            ),
            ElevatedButton(
              onPressed: () {
                _addContactToFirestore(
                  emailController.text,
                  phoneController.text,
                  addressController.text,
                );
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
              child: Text('Add', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _addContactToFirestore(String email, String phone, String address) {
    FirebaseFirestore.instance.collection('contact').add({
      'email': email,
      'phone': phone,
      'address': address,
      'uid': currentUserUid,
      'timestamp': Timestamp.now(),
    }).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Contact added successfully.'),
        ),
      );
    }).catchError((error) {
      print('Error adding contact: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error adding contact.'),
        ),
      );
    });
  }

  void _deleteContact(String contactUid, BuildContext context) {
    FirebaseFirestore.instance.collection('contact').doc(contactUid).delete().then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Contact deleted successfully.'),
        ),
      );
    }).catchError((error) {
      print('Error deleting contact: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting contact.'),
        ),
      );
    });
  }
}
