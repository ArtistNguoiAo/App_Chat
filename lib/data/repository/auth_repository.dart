import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../local_cache.dart';
import '../model/token_model.dart';
import '../model/user_model.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel> registerUser({
    required String email,
    required String password,
    required String username,
    required String firstName,
    required String lastName,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = UserModel(
        uid: userCredential.user!.uid,
        username: username,
        firstName: firstName,
        lastName: lastName,
        email: email,
      );

      await _firestore.collection('users').doc(user.uid).set(user.toMap());

      return user;
    } catch (e) {
      throw Exception('Đăng ký thất bại: $e');
    }
  }

  Future<(UserModel, TokenModel)> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = await _firestore.collection('users').doc(userCredential.user!.uid).get();

      final tokens = await userCredential.user!.getIdTokenResult();
      final refreshToken = userCredential.user?.refreshToken ?? '';
      print('Access token: ${tokens.token}');
      print('Refresh token: $refreshToken');
      final tokenModel = TokenModel(accessToken: tokens.token ?? '', refreshToken: refreshToken);

      await LocalCache.setString(StringCache.accessToken, tokenModel.accessToken);
      await LocalCache.setString(StringCache.refreshToken, tokenModel.refreshToken);

      return (UserModel.fromMap(user.data()!), tokenModel);
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  Future<TokenModel> refreshToken() async {
    try {
      final refreshToken = await LocalCache.getString(StringCache.refreshToken);
      if (refreshToken.isEmpty) throw Exception('No refresh token');

      await _auth.signInWithCustomToken(refreshToken);
      final tokens = await _auth.currentUser!.getIdTokenResult(true);
      final newRefreshToken = _auth.currentUser!.refreshToken ?? '';

      final tokenModel = TokenModel(accessToken: tokens.token ?? '', refreshToken: newRefreshToken);

      await LocalCache.setString(StringCache.accessToken, tokenModel.accessToken);
      await LocalCache.setString(StringCache.refreshToken, tokenModel.refreshToken);

      return tokenModel;
    } catch (e) {
      throw Exception('Token refresh failed: $e');
    }
  }
}
