import 'package:app_chat/core/utils/cloudinary_utils.dart';
import 'package:app_chat/data/model/chat_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatRepository {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final CloudinaryUtils _cloudinary = CloudinaryUtils();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> addNewChat({
    required List<String> members,
    required String groupName,
    required String groupAvatar,
    required String createdAt,
    required String lastMessageId,
  }) async {
    final chatModel = ChatModel(
      type: members.length > 2 ? 'group' : 'private',
      members: members,
      groupName: groupName,
      groupAvatar: groupAvatar,
      createdAt: createdAt,
      lastMessageId: lastMessageId,
    );
    await _fireStore.collection('chats').add(chatModel.toMap());
  }
}
