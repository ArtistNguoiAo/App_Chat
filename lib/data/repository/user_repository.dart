import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../core/utils/cloudinary_utils.dart';
import '../model/user_model.dart';

class UserRepository {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final CloudinaryUtils _cloudinary = CloudinaryUtils();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserModel> updateProfile({
    required UserModel user,
    required String username,
    required String firstName,
    required String lastName,
    File? imageFile,
  }) async {
    try {
      String avatarUrl = user.avatar;

      if (imageFile != null) {
        final uploadedUrl = await _cloudinary.uploadFile(imageFile, 'avatars');
        if (uploadedUrl != null) {
          avatarUrl = uploadedUrl;
        }
      }

      final updatedUser = UserModel(
        uid: user.uid,
        username: username,
        firstName: firstName,
        lastName: lastName,
        email: user.email,
        avatar: avatarUrl,
      );

      await _fireStore.collection('users').doc(user.uid).update(updatedUser.toMap());

      return updatedUser;
    } catch (e) {
      throw Exception('Update profile failed: $e');
    }
  }

  Future<void> requestAddFriend(UserModel userModel) async {
    try {
      final querySnapshot = await _fireStore.collection('users').get();
      final users = querySnapshot.docs.map((doc) {
        return UserModel.fromMap(doc.data());
      }).toList();
      final currentUser = users.firstWhere((user) => user.uid == _auth.currentUser!.uid);
      final friendRequest = {
        'fromId': currentUser.uid,
        'toId': userModel.uid,
      };
      await _fireStore.collection('requestAddFriend').add(
        friendRequest,
      );

    } catch (e) {
      throw Exception('Lấy thông tin người dùng thất bại: $e');
    }
  }
}
