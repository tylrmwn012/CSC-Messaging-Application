import 'package:final_csc_app/Read%20Data/read_contact.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'add_contact.dart' as add_contact;
import '../Chats/chat_screen.dart' as chat_screen;
import '../Firebase/auth_provider.dart';
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
  List<String> contacts = [];

  // this will be a function that GETS the contacts from firebase
  Future getContacts() async {
      contacts.clear();
      await FirebaseFirestore.instance.collection('contacts').get().then(
        (snapshot) => snapshot.docs.forEach((document) {
          print(document.reference);
          contacts.add(document.reference.id);
        }),
      );
    }

  @override
  Widget build(BuildContext context) {
    final authService = ref.read(authServiceProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text('Contacts', style: TextStyle(color: Colors.white, fontSize: 22,),),
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

              // Contacts list goes here
              Expanded(
                child: FutureBuilder(
                  future: getContacts(),
                  builder: (context, snapshot) {
                    return ListView.builder(
                      reverse: false,
                      itemCount: contacts.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8),
                          child: SizedBox(
                          height: 100,
                          child: ElevatedButton(
                              child: GetContacts(documentId: contacts[index]),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => chat_screen.ChatScreen(),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      }
                    );
                  }
                ),
              ),
            ]
          ),
        ),
      ),
    );
  }
}
