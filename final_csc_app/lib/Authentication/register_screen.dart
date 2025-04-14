import 'package:flutter/material.dart'; 
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../Firebase/auth_provider.dart';

// This screen will allow the user to register an account with the application.
// It asks for an email address, password, first name and last name.
// Ideally when registered, the screen would show a snackbar indicating such, and
// return the user to the authentication screen to log in with their credentials.


class Contacts extends ConsumerWidget {
  Contacts({super.key});
  final fnameController = TextEditingController(); // user entered first name
  final lnameController = TextEditingController(); // user entered last name
  final emailController = TextEditingController(); // user entered email
  final passwordController = TextEditingController(); // user entered password
  final cpasswordController = TextEditingController(); // user entered confirm password

  // Sign up function which takes user input of email and password (for now). 
  // If the password does not match the confrimation password, the error is displayed and 
  // the user can try again. If it does match, however, authService is called and passes inputs to
  // the signUpWithEmailandPassword function. If everything is fine, the user proceeds to the contacts
  // screen. Else, an error is displayed as a string in a SnackBar.
  void signUp(
      BuildContext context, 
      WidgetRef ref, 
      TextEditingController emailController, 
      TextEditingController passwordController, 
      TextEditingController cpasswordController, 
      TextEditingController fnameController, 
      TextEditingController lnameController) async {

    final authService = ref.read(authServiceProvider);
    if (passwordController.text != cpasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match")),
      );
      return;
    }
    try {
      await authService.signUpWithEmailandPassword(
        emailController.text,
        passwordController.text,
        fnameController.text.trim(),
        lnameController.text.trim(),
      );
      // add first name and last name to firebase
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text("Account created! Welcome to the chat app, ${fnameController.text.trim()}!",
      )));
      Navigator.pop(context); // Go back to login screen
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              Row(
                children: [
                   Flexible(
                    // First Name
                    child: TextField(
                      obscureText: false,
                      controller: fnameController,
                      decoration: const InputDecoration(
                        labelText: 'First Name',
                        labelStyle: TextStyle(color: Colors.white),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white70),
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  
                  SizedBox(width: 10.0,),
                  Flexible(
                  // Last Name
                    child: TextField(
                      obscureText: false,
                      controller: lnameController,
                      decoration: const InputDecoration(
                        labelText: 'Last Name',
                        labelStyle: TextStyle(color: Colors.white),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white70),
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ]
              ),

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
                  labelText: 'Password',
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
                  labelText: 'Confirm Password',
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
                    onPressed: () => signUp(
                      context,
                      ref,
                      emailController,
                      passwordController,
                      cpasswordController,
                      fnameController,
                      lnameController,
                    ),
                    child: const Text('Register'), 
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}






        