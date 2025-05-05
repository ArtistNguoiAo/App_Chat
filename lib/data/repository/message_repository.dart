import 'package:app_chat/data/model/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageRepository {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  Future<void> sendMessage({
    required MessageModel messageModel,
  }) async {
    await _fireStore.collection('messages').add(messageModel.toMap());

  }

  Stream<List<MessageModel>> getMessage(List<String> targetSeenBy) {
    return _fireStore.collection('messages').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => MessageModel.fromMap(doc.data()))
          .where((msg) =>
          _listEqualsIgnoreOrder(msg.seenBy, targetSeenBy))
          .toList()
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    });
  }

  bool _listEqualsIgnoreOrder(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    final aSorted = [...a]..sort();
    final bSorted = [...b]..sort();
    return aSorted.join(',') == bSorted.join(',');
  }
}
