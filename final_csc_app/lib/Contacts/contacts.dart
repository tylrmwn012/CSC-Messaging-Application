import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'add_contact.dart' as add_contact;
import '../Chats/chat_screen.dart';
import '../Firebase Auth/auth_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Chats/notifications.dart';

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
        title: Text('Contacts', style: TextStyle(color: Colors.white, fontSize: 25)),
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
                            height: 75,
                            child: ElevatedButton(
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
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                elevation: 0.0,
                            ),
                            child: Text("${contact['first name']} ${contact['last name'] ?? ''}"),
                          ),
                          )
                        );
                      },
                    );
                  },
                ),
              ),
              SizedBox(
                height: 70,
                width: 800,
                child: Row(
                  
                  // This will contain buttons at bottom of screen for :
                  children: [
                    // 1) Log Out button
                    SizedBox(
                      height: 60,
                      width: 123,
                      child: ElevatedButton(
                        onPressed: () {
                          authService.signOut();
                        }, 
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(0, 255, 255, 255),
                            elevation: 0.0,
                            shape: BeveledRectangleBorder(),
                        ),
                        child: Icon(Icons.logout_sharp, size: 30, color: Colors.white,),
                      ),
                    ),
                    // 2) Search Contacts button
                    SizedBox(
                      height: 60,
                      width: 123,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => add_contact.AddContact(),
                            ),
                          );
                        }, 
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(0, 255, 255, 255),
                            elevation: 0.0,
                            shape: BeveledRectangleBorder(),
                        ),
                        child: Icon(Icons.search_sharp, size: 30, color: Colors.white,),
                      ),
                    ),
                    // 3) Notifications Button
                    SizedBox(
                      height: 60,
                      width: 123,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Notifications(
                                receiverUserName: 'first name',
                                receiverUserID: 'uid',
                              ),
                            ),
                          );
                        }, 
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(0, 255, 255, 255),
                            elevation: 0.0,
                            shape: BeveledRectangleBorder(),
                        ),
                        child: Icon(Icons.circle_notifications_outlined, size: 30, color: Colors.white,),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
