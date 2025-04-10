import 'package:flutter/material.dart';
// This screen serves as the general chat display. At the top, the user would see 
// the contact's name. Also, it will display a full history of messages between the
// two user through as a reverse list.


class ChatScreen extends StatelessWidget {
  ChatScreen({super.key});
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0, 
        leading: const BackButton(
          color: Colors.white,
        ),   
        title: const Text('My Mentor',
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

            // Chat view
            Expanded(
              child: ListView(
                reverse: true,
                padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 7),
              ),
            ),

            // Message Input Field
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      focusNode: _focusNode,
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
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Icon(Icons.send),
                  ),
                ],
              ),
            ),


            // Handles keyboard "Enter" key press on desktop
            KeyboardListener(
              focusNode: _focusNode,
              child: const SizedBox(),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
      backgroundColor: Colors.grey[200],
    );
  }
}