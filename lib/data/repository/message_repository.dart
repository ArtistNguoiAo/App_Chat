import 'package:app_chat/data/model/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class MessageRepository {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  Future<void> sendMessage(MessageModel messageModel) async {
    await _fireStore.collection('messages').add(messageModel.toMap());
  }
}
