import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // function defined in order to sign in user to the application
  Future<UserCredential> signInWithEmailandPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, 
        password: password
      );

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // function defined in order to sign out a user from the application
  Future<void> signOut() async {
    return await FirebaseAuth.instance.signOut();
  }

  // function defined in order to register a new user to the application
  Future<UserCredential> signUpWithEmailandPassword(String email, password) async {
    try {
      
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, 
        password: password
        );
        return userCredential;

    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }


}