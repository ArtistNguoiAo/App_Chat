import 'package:app_chat/data/model/message_model.dart';

class ChatModel {
  final String type;
  final List<String> members;
  final String groupName;
  final String groupAvatar;
  final String createdAt;
  final MessageModel lastMessage;

  ChatModel({
    required this.type,
    required this.members,
    required this.groupName,
    required this.groupAvatar,
    required this.createdAt,
    required this.lastMessage,
  });

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      type: map['type'] as String,
      members: List<String>.from(map['members'] as List),
      groupName: map['groupName'] as String,
      groupAvatar: map['groupAvatar'] as String,
      createdAt: map['createdAt'] as String,
      lastMessage: MessageModel.fromMap(map['lastMessage'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'members': members,
      'groupName': groupName,
      'groupAvatar': groupAvatar,
      'createdAt': createdAt,
      'lastMessage': lastMessage.toMap(),
    };
  }
}