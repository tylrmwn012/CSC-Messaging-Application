import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:final_csc_app/Firebase/chat_service.dart';
// This screen serves as the general chat display. At the top, the user would see 
// the contact's name. Also, it will display a full history of messages between the
// two user through as a reverse list.

class ChatScreen extends StatefulWidget{
  final String receiverUserName;
  final String receiverUserID;
  const ChatScreen({super.key, required this.receiverUserName, required this.receiverUserID});

  @override
  State<ChatScreen> createState() => _ChatScreen();
}

class _ChatScreen extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final ChatService _chatService = ChatService();
    final FocusNode _focusNode = FocusNode();

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
        widget.receiverUserID, _messageController.text);
        _messageController.clear();
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0, 
        leading: const BackButton(
          color: Colors.white,
        ),   
        title: Text(widget.receiverUserName,
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
            child: _buildMessageList(),
          ),

          _buildMessageInput(),
          const SizedBox(height: 24),
        ],
        )
      )
    );
  }

  // build message list
  Widget _buildMessageList() {
    return StreamBuilder(
      stream: _chatService.getMessages(
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
          children: snapshot.data!.docs.map((document) => _buildMessageItem(document)).toList(),
        );
      }
    );
  }

  // build message item
  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    var alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid) ? Alignment.centerRight : Alignment.centerLeft;
  
    return Container(
      alignment: alignment,
      child: Column(
        children: [
          Text(data['senderEmail'], style: TextStyle(color: Colors.white),),
          Text(data['message'], style: TextStyle(color: Colors.white),),
        ]
      )
    ); 
  }

  // build message input
  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              focusNode: _focusNode,
              controller: _messageController,
              obscureText: false,
              decoration: const InputDecoration(
                        labelText: 'Send a message',
                        labelStyle: TextStyle(color: Colors.white),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white70),
                        ),
                      ),
              style: const TextStyle(color: Colors.white),
                maxLines: 3,
                minLines: 1,
                keyboardType: TextInputType.multiline,
              ),
          ),
          // send button
          const SizedBox(width: 10),
            ElevatedButton(
              onPressed: sendMessage,
              child: const Icon(Icons.send),
            ),        
          ],
        ),
      );
    }
  }