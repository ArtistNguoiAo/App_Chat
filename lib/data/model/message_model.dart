class MessageModel {
  final String userIdFrom;
  final String userIdTo;
  final String text;
  final String createdAt;

  MessageModel({
    required this.userIdFrom,
    required this.userIdTo,
    required this.text,
    required this.createdAt,
  });

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      userIdFrom: map['userIdFrom'] as String,
      userIdTo: map['userIdTo'] as String,
      text: map['text'] as String,
      createdAt: map['createdAt'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userIdFrom': userIdFrom,
      'userIdTo': userIdTo,
      'text': text,
      'createdAt': createdAt,
    };
  }
}