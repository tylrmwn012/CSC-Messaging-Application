import 'package:flutter/material.dart';

// This screen will allow the user to search for other users by their first and
// last name, then add them to their contacts list to initialize a conversation.
// When the first name is searched, everyone with that first name will display. Same
// with last name. Or both first and last name. Both should not be required.


class AddContact extends StatelessWidget {
  AddContact({super.key});
  // First name user input
  final fnameController = TextEditingController();
  // Last name user input
  final lnameController = TextEditingController();
  // Email user input
  final emailController = TextEditingController();

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
            spacing: 1,
            children: [

              // Chat view
              Expanded(
                child: ListView(
                  reverse: true,
                  padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 7),
                ),
              ),
              const SizedBox(height: 80),
              Row(

                // First Name
                children: [
                  Flexible(
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

                  // Last Name
                  SizedBox(width: 10.0,),
                  Flexible(
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
                  )
                ]
              ),

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

              // Search for user...
              SizedBox(
                  width: 250,
                  child: ElevatedButton(
                    onPressed: () {

                    },
                    child: const Text('Search'), 
                  ),
                ),

            ],
          ),
        ),
      ),
    );
  }
}






        