import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/UserModel.dart';

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

  Future<UserModel> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      return UserModel.fromMap(userDoc.data()!);
    } catch (e) {
      throw Exception('Đăng nhập thất bại: $e');
    }
  }
}