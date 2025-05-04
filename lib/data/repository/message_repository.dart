import 'package:app_chat/data/model/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class MessageRepository {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  Future<void> sendMessage(MessageModel messageModel) async {
    final message = {
      'userIdFrom': messageModel.userIdFrom,
      'userIdTo': messageModel.userIdTo,
      'text': messageModel.text,
      'createdAt': messageModel.createdAt,
    };

    await _fireStore
        .collection('chats')
        .doc(messageModel.userIdFrom)
        .collection(messageModel.userIdTo)
        .add(message);
  }

  Stream<List<MessageModel>> getMessages(String userIdFrom, String userIdTo) {
    final stream1 = _fireStore
        .collection('chats')
        .doc(userIdFrom)
        .collection(userIdTo)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => MessageModel.fromMap(doc.data())).toList());

    final stream2 = _fireStore
        .collection('chats')
        .doc(userIdTo)
        .collection(userIdFrom)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => MessageModel.fromMap(doc.data())).toList());

    return Rx.combineLatest2<List<MessageModel>, List<MessageModel>, List<MessageModel>>(
      stream1,
      stream2,
          (list1, list2) {
        final allMessages = [...list1, ...list2];

        allMessages.sort(
              (a, b) => DateTime.parse(b.createdAt).compareTo(DateTime.parse(a.createdAt)),
        );

        return allMessages;
      },
    );
  }
}
