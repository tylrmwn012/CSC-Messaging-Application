import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_csc_app/Firebase%20Chat/chat_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// this screen will display the user's notifications, which include any messages received
// will include functionality to delete notifications
class Notifications extends StatefulWidget {
  final String receiverUserName;
  final String receiverUserID;
  const Notifications({super.key, required this.receiverUserName, required this.receiverUserID});

  @override
  State<Notifications> createState() => _Notifications();
}

class _Notifications extends State<Notifications> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final ChatService _chatService = ChatService();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0, 
        leading: const BackButton(
          color: Colors.white,
        ),   
        title: Text('Notifications',
            style: TextStyle(color: Colors.white,),
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
        child: Column(
        children: [
          Expanded(
            child: _buildNotificationList(),
          ),
          const SizedBox(height: 24),
        ],
        )
      )
    );
  }

  // build notification list
  Widget _buildNotificationList() {
    return StreamBuilder(
      stream: _chatService.getNotification(
        widget.receiverUserID, _firebaseAuth.currentUser!.uid,
      ),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("Error${snapshot.error}");
        } 

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text('Error${snapshot.error}');
        }

        return ListView(
          children: snapshot.data!.docs.map((document) => _buildNotificationItem(document)).toList(),
        );
      }
    );
  }

  // build notification item
  Widget _buildNotificationItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
  
    return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
      child: Align(
        alignment: (data['senderId'] == _firebaseAuth.currentUser!.uid) ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          constraints: const BoxConstraints(minWidth: 100, maxWidth: 300),
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                        margin: const EdgeInsets.symmetric(vertical: 4.0),
                        decoration: BoxDecoration(
                          color: (data['senderId'] == _firebaseAuth.currentUser!.uid) ? Colors.green[300] : Colors.blue[300],
                          borderRadius: BorderRadius.circular(8.0),
                        ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(data['first name'], style: TextStyle(color: Colors.white),),
              Text(data['message'], style: TextStyle(color: Colors.white),),
            ]
        )
        ),
      ),
    );
  }
}