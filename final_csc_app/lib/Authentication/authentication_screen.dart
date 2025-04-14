import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'register_screen.dart' as register;
import '../Firebase Auth/auth_provider.dart';
import 'forgot_password.dart';

// This screen is where the user either logs in with an email and password. 
// Or they can move on to the register screen and register with an email and password,
// and a first name and last name.

class LogIn extends ConsumerStatefulWidget {
  const LogIn({super.key});

  @override
  ConsumerState<LogIn> createState() => _LogInState();
}

class _LogInState extends ConsumerState<LogIn> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Sign in function which takes user inputs for email and password and
  // calls authService to verify. If there's any error, it will be displayed
  // as a SnackBar.
  void signIn() async {
    final authService = ref.read(authServiceProvider);
    try {
      await authService.signInWithEmailandPassword(
        emailController.text,
        passwordController.text,
      );
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
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
            children: [
              SizedBox(
                child: Image.asset(
                  'assets/csc_logo.png',
                  scale: 2.5,
                ),
              ),
              const SizedBox(height: 50),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white70),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
                controller: emailController,
              ),
              
              TextField(
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white70),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
                controller: passwordController,
              ),

// INSERT FORGOT PASSWORD BUTTON
              TextButton(onPressed: () {
                Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ForgotPassword(),
                      ),
                    );
              }, 
                child: Text("Forgot Password?", style: TextStyle(color: Colors.white),),),



              SizedBox(
                width: 250,
                child: ElevatedButton(
                  onPressed: signIn,
                  child: const Text('Sign In'),
                ),
              ),
              const SizedBox(height: 12),
              const Text('- OR -', style: TextStyle(color: Colors.white)),
              const SizedBox(height: 12),
              SizedBox(
                width: 250,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => register.Contacts(),
                      ),
                    );
                  },
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
