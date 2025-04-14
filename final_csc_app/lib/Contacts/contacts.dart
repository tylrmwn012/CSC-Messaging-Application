import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'add_contact.dart' as add_contact;
import '../Chats/chat_screen.dart';
import '../Firebase Auth/auth_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// This screen will serve as sort of the home page of the whole app. At the top left, 
// the user can sign out and be returned to the authentication screen. At the top right, 
// the user can click a button which will allow the user to search for other contacts
// based on their first and/or last name.

// The main section is the contacts list. This will display a list of buttons that will take
// the user to previous conversation with said contact.
class Contacts extends ConsumerStatefulWidget {
  const Contacts({super.key});

  @override
  ConsumerState<Contacts> createState() => _Contacts();
}

class _Contacts extends ConsumerState<Contacts> {
  List<Map<String, dynamic>> contacts = [];

  Future<void> getContacts() async {
    contacts.clear();
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('users').get();
    
    for (var doc in snapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      data['uid'] = doc.id; // Store the document ID as UID if needed
      contacts.add(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = ref.read(authServiceProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text('Contacts', style: TextStyle(color: Colors.white, fontSize: 22)),
        leading: PopupMenuButton<String>(
          padding: EdgeInsets.zero,
          icon: Icon(Icons.menu, size: 32, color: Colors.white),
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
              Expanded(
                child: FutureBuilder(
                  future: getContacts(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return Center(child: CircularProgressIndicator());
                    }
                    return ListView.builder(
                      itemCount: contacts.length,
                      itemBuilder: (context, index) {
                        final contact = contacts[index];
                        return Padding(
                          padding: const EdgeInsets.all(8),
                          child: SizedBox(
                            height: 100,
                            child: ElevatedButton(
                              child: Text("${contact['first name']} ${contact['last name'] ?? ''}"),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatScreen(
                                      receiverUserName: contact['first name'],
                                      receiverUserID: contact['uid'],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
