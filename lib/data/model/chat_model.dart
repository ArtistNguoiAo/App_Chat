import 'package:app_chat/data/model/message_model.dart';

class ChatModel {
  final String chatId;
  final String type;
  final List<String> participants;
  final String groupName;
  final String groupAvatar;
  final String createdAt;
  final MessageModel lastMessage;

  ChatModel({
    required this.chatId,
    required this.type,
    required this.participants,
    required this.groupName,
    required this.groupAvatar,
    required this.createdAt,
    required this.lastMessage,
  });

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      chatId: map['chatId'] as String,
      type: map['type'] as String,
      participants: List<String>.from(map['participants'] as List),
      groupName: map['groupName'] as String,
      groupAvatar: map['groupAvatar'] as String,
      createdAt: map['createdAt'] as String,
      lastMessage: MessageModel.fromMap(map['lastMessage'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'chatId': chatId,
      'type': type,
      'participants': participants,
      'groupName': groupName,
      'groupAvatar': groupAvatar,
      'createdAt': createdAt,
      'lastMessage': lastMessage.toMap(),
    };
  }
}