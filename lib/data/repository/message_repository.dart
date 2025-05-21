import 'dart:convert';

import 'package:app_chat/data/model/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class MessageRepository {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future<void> sendMessage({
    required MessageModel messageModel,
    required String chatId,
  }) async {
    final documentRef = _fireStore.collection('messages').doc(chatId).collection('messages').doc();

    final updatedMessageModel = messageModel.copyWith(id: documentRef.id);

    await documentRef.set(updatedMessageModel.toMap());
  }

  Future<void> sendMessageWithNotification({
    required String chatId,
    required String message,
    required String senderId,
    required List<String> memberIds,
  }) async {
    try {
      // Save message to Firestore
      final messageRef = await _fireStore.collection('chats').doc(chatId).collection('messages').add({
        'message': message,
        'senderId': senderId,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Update last message
      await _fireStore.collection('chats').doc(chatId).update({
        'lastMessageId': messageRef.id,
        'lastMessageTime': FieldValue.serverTimestamp(),
      });

      // Get sender info
      final senderDoc = await _fireStore.collection('users').doc(senderId).get();
      final senderName = senderDoc.data()?['fullName'] ?? '';

      // Send notification to other members
      for (String memberId in memberIds) {
        if (memberId != senderId) {
          final memberDoc = await _fireStore.collection('users').doc(memberId).get();
          final fcmToken = memberDoc.data()?['fcmToken'];

          if (fcmToken != null) {
            await _sendPushNotification(
              token: fcmToken,
              title: senderName,
              body: message,
              data: {
                'chatId': chatId,
                'type': 'message',
              },
            );
          }
        }
      }
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }

  Future<void> _sendPushNotification({
    required String token,
    required String title,
    required String body,
    required Map<String, dynamic> data,
  }) async {

  }

  Stream<List<MessageModel>> getMessage({
    required String chatId,
    required List<String> targetSeenBy,
  }) {
    return _fireStore.collection('messages').doc(chatId).collection('messages').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => MessageModel.fromMap(doc.data())).where((msg) => _listEqualsIgnoreOrder(msg.seenBy, targetSeenBy)).toList()..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    });
  }

  bool _listEqualsIgnoreOrder(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    final aSorted = [...a]..sort();
    final bSorted = [...b]..sort();
    return aSorted.join(',') == bSorted.join(',');
  }

  Future<int> getMessagesCountInChat(String chatId) async {
    try {
      final AggregateQuerySnapshot snapshot = await _fireStore
          .collection('messages')
          .doc(chatId)
          .collection('messages')
          .count()
          .get();
      return snapshot.count ?? 0;
    } catch (e) {
      throw Exception('Failed to get messages count for chat $chatId: $e');
    }
  }

  Future<void> deleteMessage({
    required String chatId,
  }) async {
    try {
      // Lấy tất cả các message trong collection 'messages'
      final querySnapshot = await _fireStore
          .collection('messages')
          .doc(chatId)
          .collection('messages')
          .get();

      // Xóa từng message
      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
      }

      // Sau khi xóa hết message, xóa luôn document của chatId
      await _fireStore.collection('messages').doc(chatId).delete();
    } catch (e) {
      throw Exception('Failed to delete all messages for chat $chatId: $e');
    }
  }

}
