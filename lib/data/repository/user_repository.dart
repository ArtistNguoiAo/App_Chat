import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/utils/cloudinary_utils.dart';
import '../model/user_model.dart';

class UserRepository {
  final FirebaseFirestore _firestore;
  final CloudinaryUtils _cloudinary;

  UserRepository()
      : _firestore = FirebaseFirestore.instance,
        _cloudinary = CloudinaryUtils();

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

      await _firestore.collection('users').doc(user.uid).update(updatedUser.toMap());

      return updatedUser;
    } catch (e) {
      throw Exception('Update profile failed: $e');
    }
  }
}
