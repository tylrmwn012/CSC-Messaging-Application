import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Authentication/authentication_screen.dart';
import '../Contacts/contacts.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({ super.key });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(), 
        builder: (context, snapshot) {
          // user signed in
          if (snapshot.hasData) {
            return Contacts(); 
          }
          // user not signed in
          else {
            return LogIn();
          }
        }
        ),
    );
  }
}

