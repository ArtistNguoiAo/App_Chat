class UserModel {
  final String uid;
  final String username;
  final String firstName;
  final String lastName;
  final String email;
  final String avatar;
  final List<String> friends;

  String get fullName => '$firstName $lastName';

  UserModel({
    required this.uid,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.avatar = '',
    this.friends = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'username': username,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'avatar': avatar,
      'friends': friends,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] as String,
      username: map['username'] as String,
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      email: map['email'] as String,
      avatar: map['avatar'] as String? ?? '',
      friends: List<String>.from(map['friends'] as List<dynamic>? ?? []),
    );
  }
}