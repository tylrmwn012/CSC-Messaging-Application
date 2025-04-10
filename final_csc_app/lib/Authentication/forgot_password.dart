import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

// This screen is where the user either logs in with an email and password. 
// Or they can move on to the register screen and register with an email and password,
// and a first name and last name.
class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPassword();
}


class _ForgotPassword extends State<ForgotPassword> {
  final emailController = TextEditingController(); // user entered email

  // Sign up function which takes user input of email and password (for now). 
  // If the password does not match the confrimation password, the error is displayed and 
  // the user can try again. If it does match, however, authService is called and passes inputs to
  // the signUpWithEmailandPassword function. If everything is fine, the user proceeds to the contacts
  // screen. Else, an error is displayed as a string in a SnackBar.

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future passwordReset() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text.trim());
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("A reset email has been sent to ${emailController.text.trim()}")));
    } on FirebaseAuthException catch (e) {
      print(e);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

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
              const Text("If your email is associated with an account, you'll receive link in your inbox to reset your password.", style: TextStyle(color: Colors.white)),
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

              // Initialize CHange Password
              SizedBox(
                  width: 250,
                  child: ElevatedButton(
                    onPressed: () => passwordReset(),
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






        
