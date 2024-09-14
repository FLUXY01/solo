import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthServices extends ChangeNotifier{
  // instance of firebase auth
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  // instance of firestore
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  // Signin method
  Future<UserCredential> signInWithEmailAndPassword(String email, String password) async{
    try{
      //signin method
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      // store users data in users collection if it doesnt exist
      firestore.collection("users").doc(userCredential.user!.uid).set(
        {
          "uid": userCredential.user!.uid,
          "email": email,
        },
        SetOptions(merge: true)
      );

      return userCredential;
    } on FirebaseAuthException catch(e){
      throw Exception(e.code);
    }
  }
  // create a new user
  Future<UserCredential>createUserWithEmailAndPassword(String email, String password) async{
    try{
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      // store the user details
      firestore.collection("users").doc(userCredential.user!.uid).set(
        {
          "uid": userCredential.user!.uid,
          "email": email,
        },
      );
      return userCredential;
    } on FirebaseAuthException catch(e){
      throw Exception(e.code);
    }
  }
  // signout method
Future<void> signOut() async{
    return await FirebaseAuth.instance.signOut();
}
}