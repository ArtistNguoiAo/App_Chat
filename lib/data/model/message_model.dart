class MessageModel {
  final String userIdSend;
  final String text;
  final String createdAt;
  final List<String> seenBy;

  MessageModel({
    required this.userIdSend,
    required this.text,
    required this.createdAt,
    required this.seenBy,
  });

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      userIdSend: map['userIdSend'] as String,
      text: map['text'] as String,
      createdAt: map['createdAt'] as String,
      seenBy: List<String>.from(map['seenBy'] as List),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userIdSend': userIdSend,
      'text': text,
      'createdAt': createdAt,
      'seenBy': seenBy,
    };
  }
}