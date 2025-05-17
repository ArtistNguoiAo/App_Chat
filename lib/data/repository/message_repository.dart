import 'package:app_chat/data/model/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageRepository {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  Future<void> sendMessage({
    required MessageModel messageModel,
    required String chatId,
  }) async {
    final documentRef = _fireStore.collection('messages').doc(chatId).collection('messages').doc();

    final updatedMessageModel = messageModel.copyWith(id: documentRef.id);

    await documentRef.set(updatedMessageModel.toMap());
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
      print('Error getting messages count for chat $chatId: $e');
      // Consider how you want to handle errors, e.g., rethrow or return a default.
      // For now, rethrowing to be consistent with other repository methods.
      throw Exception('Failed to get messages count for chat $chatId: $e');
    }
  }
}
