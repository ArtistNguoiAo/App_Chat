import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../local_cache.dart';
import '../model/token_model.dart';
import '../model/user_model.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

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

      await _fireStore.collection('users').doc(user.uid).set(user.toMap());

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

      final user = await _fireStore.collection('users').doc(userCredential.user!.uid).get();

      final tokens = await userCredential.user!.getIdTokenResult();
      final refreshToken = userCredential.user?.refreshToken ?? '';
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

  Future<bool> verifyCurrentPassword(String password) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not found');

      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );

      await user.reauthenticateWithCredential(credential);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> changePassword(String currentPassword, String newPassword) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not found');

      // Verify current password first
      final isValid = await verifyCurrentPassword(currentPassword);
      if (!isValid) throw Exception('Current password is incorrect');

      await user.updatePassword(newPassword);
    } catch (e) {
      throw Exception('Failed to change password: $e');
    }
  }

  Future<void> forgotPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw Exception('Failed to send password reset email: $e');
    }
  }

  Future<List<UserModel>> getAllUsers() async {
    try {
      final querySnapshot = await _fireStore.collection('users').get();
      final users = querySnapshot.docs.map((doc) {
        return UserModel.fromMap(doc.data());
      }).toList();

      users.removeWhere((user) => user.uid == _auth.currentUser!.uid);

      return users;
    } catch (e) {
      throw Exception('Lấy danh sách người dùng thất bại: $e');
    }
  }

  Future<UserModel> getCurrentUser() async {
    try {
      final querySnapshot = await _fireStore.collection('users').get();
      final users = querySnapshot.docs.map((doc) {
        return UserModel.fromMap(doc.data());
      }).toList();
      return users.firstWhere((user) => user.uid == _auth.currentUser!.uid);

    } catch (e) {
      throw Exception('Lấy thông tin người dùng thất bại: $e');
    }
  }

  Stream<List<UserModel>> getListFriendStream(UserModel user) {
    return _fireStore.collection('users').snapshots().map((querySnapshot) {
      final users = querySnapshot.docs.map((doc) {
        return UserModel.fromMap(doc.data());
      }).toList();

      return users.where((friend) => user.friends.contains(friend.uid)).toList();
    });
  }

  Future<void> updateFcmToken(String uid, String fcmToken) async {
    try {
      await _fireStore.collection('users').doc(uid).update({
        'fcmToken': fcmToken,
        'status': 'online'
      });
    } catch (e) {
      throw Exception('Failed to update FCM token: $e');
    }
  }
}
