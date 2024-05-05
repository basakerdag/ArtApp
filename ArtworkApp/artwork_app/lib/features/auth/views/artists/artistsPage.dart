import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ArtistsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Artists Page'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('artists').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          final List<DocumentSnapshot> artists = snapshot.data!.docs;

          return ListView.separated(
            itemCount: artists.length,
            separatorBuilder: (BuildContext context, int index) => Divider(),
            itemBuilder: (context, index) => _buildArtistItem(context, artists[index]),
          );
        },
      ),
      floatingActionButton: _buildFloatingActionButton(context),
    );
  }

  Widget _buildArtistItem(BuildContext context, DocumentSnapshot artistSnapshot) {
    final artist = artistSnapshot.data() as Map<String, dynamic>;
    final String artistName = artist['artistName'] ?? '';
    final String country = artist['country'] ?? '';
    final currentUserUid = FirebaseAuth.instance.currentUser?.uid;

    return ListTile(
      title: Text(
        artistName,
        style: TextStyle(color: Colors.white),
      ),
      subtitle: Text(
        country,
        style: TextStyle(color: Colors.white),
      ),
      trailing: currentUserUid == 'XS0BdY1k6vcAyVWA1jWdljyGnoh1'
          ? IconButton(
              icon: Icon(Icons.delete),
              color: Colors.red,
              onPressed: () {
                _deleteArtist(context, artistSnapshot.id);
              },
            )
          : null,
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    final currentUserUid = FirebaseAuth.instance.currentUser?.uid;

    if (currentUserUid != null && currentUserUid == 'XS0BdY1k6vcAyVWA1jWdljyGnoh1') {
      return FloatingActionButton(
        onPressed: () {
          _addNewArtist(context);
        },
        child: Icon(Icons.add),
      );
    } else {
      return Container();
    }
  }

  void _addNewArtist(BuildContext context) {
    String artistName = '';
    String country = '';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add New Artist'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Artist Name'),
                onChanged: (value) {
                  artistName = value;
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Country'),
                onChanged: (value) {
                  country = value;
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
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (artistName.isNotEmpty && country.isNotEmpty) {
                _uploadArtistToFirestore(context, artistName, country);
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Please enter artist name and country.'),
                  ),
                );
              }
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  void _uploadArtistToFirestore(BuildContext context, String artistName, String country) async {
    try {
      await FirebaseFirestore.instance.collection('artists').add({
        'artistName': artistName,
        'country': country,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Artist added successfully.'),
        ),
      );
    } catch (e) {
      print('Error adding artist: $e');
    }
  }

  void _deleteArtist(BuildContext context, String artistId) async {
    try {
      await FirebaseFirestore.instance.collection('artists').doc(artistId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Artist deleted successfully.'),
        ),
      );
    } catch (e) {
      print('Error deleting artist: $e');
    }
  }
}
