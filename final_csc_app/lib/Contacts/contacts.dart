import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'add_contact.dart' as add_contact;
import '../Chats/chat_screen.dart' as chat_screen;
import '../Firebase/auth_provider.dart';

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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: PopupMenuButton<String>(
          padding: EdgeInsets.zero,
          icon: Icon(Icons.menu, size: 32, color: Colors.white), // bigger icon
          onSelected: (String choice) {
            switch (choice) {
              case 'Logout':
                authService.signOut();
                break;
              case 'Add Contact':
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => add_contact.AddContact(),
                  ),
                );
                break;
            }
          },
          itemBuilder: (BuildContext context) {
            return {'Logout', 'Add Contact'}.map((String choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: Text(choice),
              );
            }).toList();
          },
        ),
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
            children: [
              const SizedBox(height: 110), // pushed down to make space for AppBar
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
                  // Contacts list goes here
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
