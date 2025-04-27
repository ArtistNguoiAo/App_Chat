class TokenModel {
  final String accessToken;
  final String refreshToken;

  TokenModel({required this.accessToken, required this.refreshToken});

  Map<String, dynamic> toMap() => {
        'accessToken': accessToken,
        'refreshToken': refreshToken,
      };

  factory TokenModel.fromMap(Map<String, dynamic> map) => TokenModel(
        accessToken: map['accessToken'] as String,
        refreshToken: map['refreshToken'] as String,
      );
}
