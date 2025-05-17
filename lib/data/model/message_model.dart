class MessageModel {
  final String id;
  final String userIdSend;
  final String text;
  final String createdAt;
  final List<String> seenBy;
  final String type;

  MessageModel({
    required this.id,
    required this.userIdSend,
    required this.text,
    required this.createdAt,
    required this.seenBy,
    required this.type,
  });

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      id: map['id'] as String,
      userIdSend: map['userIdSend'] as String,
      text: map['text'] as String,
      createdAt: map['createdAt'] as String,
      seenBy: List<String>.from(map['seenBy'] as List),
      type: map['type'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userIdSend': userIdSend,
      'text': text,
      'createdAt': createdAt,
      'seenBy': seenBy,
      'type': type,
    };
  }

  MessageModel copyWith({
    String? id,
    String? userIdSend,
    String? text,
    String? createdAt,
    List<String>? seenBy,
    String? type,
  }) {
    return MessageModel(
      id: id ?? this.id,
      userIdSend: userIdSend ?? this.userIdSend,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
      seenBy: seenBy ?? List.from(this.seenBy),
      type: type ?? this.type,
    );
  }
}