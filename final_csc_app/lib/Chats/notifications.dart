import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_csc_app/Firebase Chat/chat_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'chat_screen.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final ChatService _chatService = ChatService();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  List<Map<String, dynamic>> contacts = [];

  @override
  void initState() {
    super.initState();
    _initializeLocalNotifications();
    _listenForNewNotifications();
    _getContacts();
  }

  Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(initSettings);
  }

  void _listenForNewNotifications() {
    final currentUserId = _firebaseAuth.currentUser?.uid;
    if (currentUserId == null) return;

    _chatService.getNotifications(currentUserId).listen((snapshot) {
      for (var doc in snapshot.docChanges) {
        if (doc.type == DocumentChangeType.added) {
          final data = doc.doc.data() as Map<String, dynamic>;

          if (data['senderId'] != currentUserId) {
            final String sender = data['senderEmail'] ?? 'Someone';
            final String message = data['message'] ?? '';

            flutterLocalNotificationsPlugin.show(
              DateTime.now().millisecondsSinceEpoch ~/ 1000,
              'Message from $sender',
              message,
              const NotificationDetails(
                android: AndroidNotificationDetails(
                  'messages_channel',
                  'Messages',
                  channelDescription: 'Incoming messages',
                  importance: Importance.max,
                  priority: Priority.high,
                ),
              ),
            );
          }
        }
      }
    });
  }

  Future<void> _getContacts() async {
    contacts.clear();
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('users').get();

    for (var doc in snapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      data['uid'] = doc.id;
      contacts.add(data);
    }

    setState(() {}); // Refresh UI if needed
  }

  @override
  Widget build(BuildContext context) {
    final userId = _firebaseAuth.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: const BackButton(color: Colors.white),
        title:
            const Text('Notifications', style: TextStyle(color: Colors.white)),
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
              child: userId == null
                  ? const Center(child: Text("User not logged in"))
                  : _buildNotificationList(userId),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationList(String userId) {
    return StreamBuilder(
      stream: _chatService.getNotifications(userId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final docs = snapshot.data?.docs
            .where((doc) =>
                (doc.data() as Map<String, dynamic>)['senderId'] != userId)
            .toList();

        if (docs == null || docs.isEmpty) {
          return const Center(child: Text("No incoming notifications"));
        }

        return ListView(
          children: docs.map((doc) => _buildNotificationItem(doc)).toList(),
        );
      },
    );
  }

  Widget _buildNotificationItem(DocumentSnapshot document) {
    final data = document.data() as Map<String, dynamic>;
    final bool isRead = data['isRead'] ?? false;

    return GestureDetector(
      onTap: () {
        final userId = _firebaseAuth.currentUser!.uid;
        _chatService.markNotificationAsRead(userId, document.id);

        final matchingContact = contacts.firstWhere(
          (contact) => contact['uid'] == data['senderId'],
          orElse: () => {},
        );

        if (matchingContact.isNotEmpty) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatScreen(
                receiverUserName: matchingContact['first name'],
                receiverUserID: matchingContact['uid'],
              ),
            ),
          );
        } else {
          print('Contact not found for UID: ${data['senderId']}');
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Container(
            width: 400,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            margin: const EdgeInsets.symmetric(vertical: 4.0),
            decoration: BoxDecoration(
              color: isRead
                  ?  const Color.fromARGB(123, 255, 255, 255)
                  : Colors.white,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data['senderEmail'] ?? '',
                    style: const TextStyle(color: Colors.black)),
                Text('Sent a Message',
                    style: const TextStyle(color: Colors.black)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
