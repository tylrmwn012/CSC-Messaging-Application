import 'package:final_csc_app/Read%20Data/add_contact_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// This screen will allow the user to search for other users by their first and
// last name, then add them to their contacts list to initialize a conversation.
// When the first name is searched, everyone with that first name will display. Same
// with last name. Or both first and last name. Both should not be required.
class AddContact extends ConsumerStatefulWidget {
  const AddContact({super.key});

  @override
  ConsumerState<AddContact> createState() => _AddContact();
}

class _AddContact extends ConsumerState<AddContact> {
  final fnameController = TextEditingController();
  final lnameController = TextEditingController();

  // get list of other users for user search
  List<String> docIDs = [];
  List<String> filteredUsers = [];  // duplicate list to be altered 

  Future getDocID() async {
    docIDs.clear();
    await FirebaseFirestore.instance.collection('users').get().then(
      (snapshot) => snapshot.docs.forEach((document) {
        print(document.reference);
        docIDs.add(document.reference.id);
      }),
    );
  }

  Future filterUsers() async {
    filteredUsers.clear(); // clears the list completely

    final fname = fnameController.text.trim().toLowerCase(); // fname is the input first name all lowercase
    final lname = lnameController.text.trim().toLowerCase();

    for (var docId in docIDs) { // for every element in docIDs
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(docId).get(); // get their data
      Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>; 

      final userFname = (data['first name']).toString().toLowerCase(); 
      final userLname = (data['last name']).toString().toLowerCase();

      final fnameMatch = fname.isEmpty || userFname == fname;
      final lnameMatch = lname.isEmpty || userLname == lname;

      // Only add if at least one field matches
      if (fnameMatch && lnameMatch) {
        filteredUsers.add(docId);
      }
    }

    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(  
      appBar: AppBar(
        title: Text('Add Contacts', style: TextStyle(color: Colors.white, fontSize: 25)),
        leading: const BackButton(
          color: Colors.white,
        ),  
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
              const SizedBox(height: 100),
              // List of every user
              Expanded(
                child: ListView.builder(
                  reverse: true,
                  itemCount: filteredUsers.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8),
                      child: SizedBox(
                        height: 75,
                        child: ElevatedButton(
                          child: GetUserName(documentId: filteredUsers[index]),
                          onPressed: () {
                            // Here we want to take the information of the button clicked
                            // Then add a button to the other screen with that person they clicked on
                            // This involves data handling with firebase:
                                // Create a database and store a user's contacts in it
                                // Then on the other screen, we display all of the person's contacts from that database

                            // Add infromation FROM button TO user's contacts list
                            // 1) initialize a collection in firestore
                            // 2) add contact to that collection
                            // 3) display all contacts on the screen

                          },
                        ),
                      ),
                    );
                  },
                ),
              ),


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


              // Search for user...
              SizedBox(
                  width: 250,
                  child: ElevatedButton(
                    onPressed: () async {
                      await getDocID();
                      await filterUsers();
                      print(filteredUsers);
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



        