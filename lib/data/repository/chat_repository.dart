import 'dart:io';

import 'package:app_chat/core/utils/cloudinary_utils.dart';
import 'package:app_chat/data/model/chat_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class ChatRepository {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final CloudinaryUtils _cloudinary = CloudinaryUtils();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<List<ChatModel>> getAllChats() async {

    final snapshot = await _fireStore.collection('chats').get();

    return snapshot.docs.map((doc) => ChatModel.fromMap(doc.data())).toList();
  }

  Future<void> addNewChat({
    required List<String> members,
    required String groupName,
    required String createdAt,
  }) async {
    final documentRef = _fireStore.collection('chats').doc();

    final chatModel = ChatModel(
      id: documentRef.id,
      type: members.length > 2 ? 'group' : 'private',
      members: members,
      groupName: groupName,
      groupAvatar: '',
      createdAt: createdAt,
      lastMessage: '',
      lastMessageTime: '',
      lastMessageSenderId: '',
      lastMessageId: '',
      lastMessageSenderName: '',
    );

    await documentRef.set(chatModel.toMap());
  }

  Future<void> updateChat({
    required String chatId,
    String? groupName,
    File? groupAvatar,
    String? lastMessage,
    DateTime? lastMessageTime,
    String? lastMessageSenderId,
    String? lastMessageSenderName,
  }) async {
    try {
      final chatRef = _fireStore.collection('chats').doc(chatId);
      final chatData = <String, dynamic>{};

      String avatar = '';

      if (groupAvatar != null) {
        final uploadedUrl = await _cloudinary.uploadFile(groupAvatar, 'avatars');
        if (uploadedUrl != null) {
          avatar = uploadedUrl;
        }
      }

      if (groupName != null) {
        chatData['groupName'] = groupName;
      }
      if (groupAvatar != null) {
        chatData['groupAvatar'] = avatar;
      }
      if (lastMessage != null) {
        chatData['lastMessage'] = lastMessage;
      }
      if (lastMessageTime != null) {
        chatData['lastMessageTime'] = lastMessageTime;
      }
      if (lastMessageSenderId != null) {
        chatData['lastMessageSenderId'] = lastMessageSenderId;
      }
      if (lastMessageSenderName != null) {
        chatData['lastMessageSenderName'] = lastMessageSenderName;
      }

      await chatRef.update(chatData);
    } catch (e) {
      throw Exception('Failed to update chat: $e');
    }
  }

  Future<void> deleteChat({
    required String chatId,
  }) async {
    try {
      await _fireStore.collection('chats').doc(chatId).delete();
    } catch (e) {
      throw Exception('Failed to delete chat: $e');
    }
  }

  Stream<List<ChatModel>> streamAllChats() {
    return _fireStore
        .collection('chats')
        .orderBy('lastMessageTime', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => ChatModel.fromMap(doc.data())).toList());
  }

  Stream<List<ChatModel>> streamUserChats(String userId) {
    return _fireStore
        .collection('chats')
        .where('members', arrayContains: userId)
        .orderBy('lastMessageTime', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => ChatModel.fromMap(doc.data())).toList());
  }
}
