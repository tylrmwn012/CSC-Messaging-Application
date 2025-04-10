import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// This screen is where the user either logs in with an email and password. 
// Or they can move on to the register screen and register with an email and password,
// and a first name and last name.

class ForgotPassword extends ConsumerStatefulWidget {
  const ForgotPassword({super.key});

  @override
  ConsumerState<ForgotPassword> createState() => _ForgotPassword();
}


class _ForgotPassword extends ConsumerState<ForgotPassword> {
  final emailController = TextEditingController(); // user entered email
  final passwordController = TextEditingController(); // user entered password
  final cpasswordController = TextEditingController(); // user entered confirm password

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
      ),
      extendBodyBehindAppBar: true,      body: 
      Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.lightBlue, Colors.orangeAccent],
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 20,
            children: [

              // Email
              TextField(
                obscureText: false,
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white70),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),

              // Password
              TextField(
                obscureText: true,
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: 'New Password',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white70),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),

              // Confirm Password
              TextField(
                obscureText: true,
                controller: cpasswordController,
                decoration: const InputDecoration(
                  labelText: 'Confirm New Password',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white70),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),

              // Create Account 
              SizedBox(
                  width: 250,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text('Change Password'), 
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}






        
