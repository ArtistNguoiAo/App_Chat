class UserModel {
  final String uid;
  final String username;
  final String firstName;
  final String lastName;
  final String email;
  final String avatar;

  String get fullName => '$firstName $lastName';

  UserModel({
    required this.uid,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.avatar = 'https://ui-avatars.com/api/?name=User&background=random',
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'username': username,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'avatar': avatar,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] as String,
      username: map['username'] as String,
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      email: map['email'] as String,
      avatar: map['avatar'] as String? ?? 'https://ui-avatars.com/api/?name=User&background=random',
    );
  }
}