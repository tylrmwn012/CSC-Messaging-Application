import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'add_contact.dart' as add_contact;
import '../Chats/chat_screen.dart' as chat_screen;
import '../Firebase/auth_providers.dart';

// This screen will serve as sort of the home page of the whole app. At the top left, 
// the user can sign out and be returned to the authentication screen. At the top right, 
// the user can click a button which will allow the user to search for other contacts
// based on their first and/or last name.

// The main section is the contacts list. This will display a list of buttons that will take
// the user to previous conversation with said contact.

class Contacts extends ConsumerWidget {
  const Contacts({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authService = ref.read(authServiceProvider);

    return Scaffold(
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
            children: [
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: SizedBox(
                      width: 150,
                      child: ElevatedButton(
                        onPressed: () {
                          authService.signOut(); // authService signOut function called here; returns user to authentication screen
                        },
                        child: const Text('Sign Out'),
                      ),
                    ),
                  ),
                  Flexible(
                    child: SizedBox(
                      width: 150,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => add_contact.AddContact(),
                            ),
                          );
                        },
                        child: const Text('Add Contact'),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 100.0,
                width: 500,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => chat_screen.ChatScreen(),
                      ),
                    );
                  },
                  child: const Text('My Mentor'),
                ),
              ),
              Expanded(
                child: ListView(
                  reverse: true,
                  padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 7),
                  // To-do: render contacts dynamically here
                  // The main section is the contacts list. This will display a list of buttons that will take
                  // the user to previous conversation with said contact.
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
