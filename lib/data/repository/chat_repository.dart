import 'package:app_chat/core/utils/cloudinary_utils.dart';
import 'package:app_chat/data/model/chat_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
    required String groupAvatar,
    required String createdAt,
    required String lastMessageId,
  }) async {
    final documentRef = _fireStore.collection('chats').doc();

    final chatModel = ChatModel(
      id: documentRef.id,
      type: members.length > 2 ? 'group' : 'private',
      members: members,
      groupName: groupName,
      groupAvatar: groupAvatar,
      createdAt: createdAt,
      lastMessageId: lastMessageId,
    );

    await documentRef.set(chatModel.toMap());
  }
}
