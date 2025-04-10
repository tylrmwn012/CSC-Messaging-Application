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
  // First name user input
  final fnameController = TextEditingController();
  // Last name user input
  final lnameController = TextEditingController();
  // Email user input
  final emailController = TextEditingController();

  // get list of other users for user search
  List<String> docIDs = [];
  List<String> filteredUsers = [];  // duplicate list to be altered 

  Future getDocID() async {
    await FirebaseFirestore.instance.collection('users').get().then(
      (snapshot) => snapshot.docs.forEach((document) {
        print(document.reference);
        docIDs.add(document.reference.id);
        filteredUsers.add(document.reference.id); // duplicate list to be altered
      }),
    );
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
                child: FutureBuilder(
                  future: getDocID(),
                  builder: (context, snapshot) {
                    return ListView.builder(
                      reverse: true,
                      itemCount: docIDs.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8),
                          child: SizedBox(
                          height: 100,
                          child: ElevatedButton(
                              child: GetUserName(documentId: docIDs[index]),
                              onPressed: () {
                                // ADD CONTACT TO CONTACTS PAGE
                              },
                            ),
                          ),
                        );
                      }
                    );
                  }
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
                      /*  LOGIC AT BOTTOM OF SCREEN */
                      // onPressed = call function to filter list...
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


/* 


function that filters the users in the list {

    for i in docIDs :

        if fnameController == something :
            if (first name != fnameController):
                remove the user from the secondDocIDs

        
        if lnameController == something :
            if (last name != lnameController):
               remove the user from the secondDocIDs
        
        
        if emailController == something :
            if (email != emailController):
                remove the user from the secondDocIDs
}

    - we should keep the old list in case they make another search
        for example, they clear their parameters and hit search.
        it should display the full list again...



*/



        