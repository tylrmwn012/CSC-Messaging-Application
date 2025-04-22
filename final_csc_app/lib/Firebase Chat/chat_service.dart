import 'package:final_csc_app/Model/message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  // SEND 
  Future<void> sendMessage(String receiverId, String message) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) return;

    final String currentUserId = user.uid;
    final String currentUserEmail = user.email.toString();
    final Timestamp timestamp = Timestamp.now();

    Message newMessage = Message(
      senderId: currentUserId,
      senderEmail: currentUserEmail,
      receiverId: receiverId,
      timestamp: timestamp,
      message: message,
    );

    List<String> ids = [currentUserId, receiverId];
    ids.sort();
    String chatRoomId = ids.join("_");

    try {
      // Save to chat room
      await _fireStore
          .collection('chat_rooms')
          .doc(chatRoomId)
          .collection('messages')
          .add(newMessage.toMap());

      // Save notification to receiver's personal collection
      await _fireStore
          .collection('notifications')
          .doc(receiverId)
          .collection('notifications')
          .add({
            ...newMessage.toMap(),
            'isRead': false,
          });
    } catch (e) {
      debugPrint('Error sending message: $e');
    }
  }

  // GET messages between two users
  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");

    return _fireStore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  // GET all notifications for a user
  Stream<QuerySnapshot> getNotifications(String userId) {
    return _fireStore
        .collection('notifications')
        .doc(userId)
        .collection('notifications')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  // MARK a notification as read
  Future<void> markNotificationAsRead(String userId, String notificationId) async {
    await _fireStore
        .collection('notifications')
        .doc(userId)
        .collection('notifications')
        .doc(notificationId)
        .update({'isRead': true});
  }
}
