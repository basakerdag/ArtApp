import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
//import 'package:appartwork12/models/user.model.dart';

final authRepositoryProvider=
Provider((ref)=>AuthRepository(auth: FirebaseAuth.instance,firebaseFirestore: FirebaseFirestore.instance ));

class AuthRepository{
  final FirebaseFirestore firebaseFirestore;
  final FirebaseAuth auth;
  AuthRepository({
    required this.auth,
    required this.firebaseFirestore,
  });

Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

Future <void>signOut() async{
  await auth.signOut();
}

Future <void> storeUserInfoToFirebase (userModel)async{
  userModel.profilePhoto ??=
  "https://pixabay.com/tr/vectors/bo%C5%9F-profil-resmi-gizemli-adam-avatar-973460/";

userModel.uid=auth.currentUser!.uid;

  await firebaseFirestore
  .collection("users")
  .doc(auth.currentUser!.uid)
  .set(userModel.toMap()); 
}





}