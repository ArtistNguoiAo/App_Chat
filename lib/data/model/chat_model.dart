import 'package:app_chat/data/model/message_model.dart';

class ChatModel {
  final String id;
  final String type;
  final List<String> members;
  final String groupName;
  final String groupAvatar;
  final String createdAt;
  final String lastMessageId;

  ChatModel({
    required this.id,
    required this.type,
    required this.members,
    required this.groupName,
    required this.groupAvatar,
    required this.createdAt,
    required this.lastMessageId,
  });

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      id: map['id'] as String,
      type: map['type'] as String,
      members: List<String>.from(map['members'] as List),
      groupName: map['groupName'] as String,
      groupAvatar: map['groupAvatar'] as String,
      createdAt: map['createdAt'] as String,
      lastMessageId: map['lastMessageId'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'members': members,
      'groupName': groupName,
      'groupAvatar': groupAvatar,
      'createdAt': createdAt,
      'lastMessageId': lastMessageId,
    };
  }
}