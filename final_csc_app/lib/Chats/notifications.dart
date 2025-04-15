import 'package:flutter/material.dart';

// This screen is where the user either logs in with an email and password. 
// Or they can move on to the register screen and register with an email and password,
// and a first name and last name.
class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _Notifications();
}


class _Notifications extends State<Notifications> {
  // Sign up function which takes user input of email and password (for now). 
  // If the password does not match the confrimation password, the error is displayed and 
  // the user can try again. If it does match, however, authService is called and passes inputs to
  // the signUpWithEmailandPassword function. If everything is fine, the user proceeds to the contacts
  // screen. Else, an error is displayed as a string in a SnackBar.

  @override
  Widget build(BuildContext context) {
    return Scaffold(  
      appBar: AppBar(
        leading: const BackButton(
          color: Colors.white,
        ),  
        backgroundColor: Colors.transparent,
        elevation: 0.0,        
        title: Text('Notifications', style: TextStyle(color: Colors.white, fontSize: 22)),
      ),
      extendBodyBehindAppBar: true,      
      body: 
      Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.lightBlue, Colors.orangeAccent],
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
          ),
        ),
        ),
      );
  }
}






        
