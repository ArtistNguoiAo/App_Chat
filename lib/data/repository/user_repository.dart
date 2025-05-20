import 'dart:ffi';
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
        friends: user.friends,
        friendRequests: user.friendRequests,
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

      final listRequest = userModel.friendRequests;
      listRequest.add(currentUser.uid);
      final updatedUser = UserModel(
        uid: userModel.uid,
        username: userModel.username,
        firstName: userModel.firstName,
        lastName: userModel.lastName,
        email: userModel.email,
        avatar: userModel.avatar,
        friends: userModel.friends,
        friendRequests: listRequest,
      );
      await _fireStore.collection('users').doc(userModel.uid).update(updatedUser.toMap());

    } catch (e) {
      throw Exception('Lấy thông tin người dùng thất bại: $e');
    }
  }

  Future<void> unRequestAddFriend(UserModel userModel) async {
    try {
      final querySnapshot = await _fireStore.collection('users').get();
      final users = querySnapshot.docs.map((doc) {
        return UserModel.fromMap(doc.data());
      }).toList();
      final currentUser = users.firstWhere((user) => user.uid == _auth.currentUser!.uid);

      final listRequest = userModel.friendRequests;
      listRequest.remove(currentUser.uid);
      final updatedUser = UserModel(
        uid: userModel.uid,
        username: userModel.username,
        firstName: userModel.firstName,
        lastName: userModel.lastName,
        email: userModel.email,
        avatar: userModel.avatar,
        friends: userModel.friends,
        friendRequests: listRequest,
      );
      await _fireStore.collection('users').doc(userModel.uid).update(updatedUser.toMap());

    } catch (e) {
      throw Exception('Lấy thông tin người dùng thất bại: $e');
    }
  }

  Future<void> acceptFriend(UserModel userModel, bool check) async {
    try {
      final querySnapshot = await _fireStore.collection('users').get();
      final users = querySnapshot.docs.map((doc) {
        return UserModel.fromMap(doc.data());
      }).toList();
      final currentUser = users.firstWhere((user) => user.uid == _auth.currentUser!.uid);

      final listRequest = currentUser.friendRequests;
      listRequest.remove(userModel.uid);
      final listFriend = currentUser.friends;

      final listFriendUser = userModel.friends;

      if(check) {
        listFriend.add(userModel.uid);
        listFriendUser.add(currentUser.uid);
      }

      final updatedUser = UserModel(
        uid: userModel.uid,
        username: userModel.username,
        firstName: userModel.firstName,
        lastName: userModel.lastName,
        email: userModel.email,
        avatar: userModel.avatar,
        friends: listFriendUser,
        friendRequests: userModel.friendRequests,
      );
      await _fireStore.collection('users').doc(userModel.uid).update(updatedUser.toMap());

      final updatedCurrentUser = UserModel(
        uid: currentUser.uid,
        username: currentUser.username,
        firstName: currentUser.firstName,
        lastName: currentUser.lastName,
        email: currentUser.email,
        avatar: currentUser.avatar,
        friends: listFriend,
        friendRequests: listRequest,
      );
      await _fireStore.collection('users').doc(currentUser.uid).update(updatedCurrentUser.toMap());

    } catch (e) {
      throw Exception('Lấy thông tin người dùng thất bại: $e');
    }
  }

  Future<void> deleteFriend({required UserModel userModel}) async {
    try {
      final querySnapshot = await _fireStore.collection('users').get();
      final users = querySnapshot.docs.map((doc) {
        return UserModel.fromMap(doc.data());
      }).toList();
      final currentUser = users.firstWhere((user) => user.uid == _auth.currentUser!.uid);

      final listFriend = currentUser.friends;
      listFriend.remove(userModel.uid);
      final listFriendUser = userModel.friends;
      listFriendUser.remove(currentUser.uid);

      final updatedUser = UserModel(
        uid: userModel.uid,
        username: userModel.username,
        firstName: userModel.firstName,
        lastName: userModel.lastName,
        email: userModel.email,
        avatar: userModel.avatar,
        friends: listFriendUser,
        friendRequests: userModel.friendRequests,
      );
      await _fireStore.collection('users').doc(userModel.uid).update(updatedUser.toMap());

      final updatedCurrentUser = UserModel(
        uid: currentUser.uid,
        username: currentUser.username,
        firstName: currentUser.firstName,
        lastName: currentUser.lastName,
        email: currentUser.email,
        avatar: currentUser.avatar,
        friends: listFriend,
        friendRequests: currentUser.friendRequests,
      );
      await _fireStore.collection('users').doc(currentUser.uid).update(updatedCurrentUser.toMap());

    } catch (e) {
      throw Exception('Lấy thông tin người dùng thất bại: $e');
    }
  }
}
