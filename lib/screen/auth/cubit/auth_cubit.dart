import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

import '../../../data/local_cache.dart';
import '../../../data/model/user_model.dart';
import '../../../data/repository/auth_repository.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository = GetIt.instance<AuthRepository>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AuthCubit() : super(AuthInitial());

  Stream<List<String>> get friendRequestsStream =>
      FirebaseFirestore.instance
          .collection('users')
          .doc(_auth.currentUser?.uid)
          .snapshots()
          .map((doc) => List<String>.from(doc.data()?['friendRequests'] ?? []));

  Future<void> checkAuthState() async {
    emit(AuthLoading());
    try {
      final accessToken = await LocalCache.getString(StringCache.accessToken);

      if (accessToken.isEmpty) {
        emit(AuthUnauthenticated());
        return;
      }

      try {
        final currentUser = _auth.currentUser;
        if (currentUser == null) {
          // Try auto login if remember me is enabled
          final email = await LocalCache.getString(StringCache.email);
          final password = await LocalCache.getString(StringCache.password);

          if (email.isNotEmpty && password.isNotEmpty) {
            final (user, _) = await _authRepository.loginUser(
              email: email,
              password: password,
            );
            emit(AuthAuthenticated(user));
            return;
          }
          throw Exception();
        }

        final userDoc = await _firestore.collection('users').doc(currentUser.uid).get();
        emit(AuthAuthenticated(UserModel.fromMap(userDoc.data()!)));
      } catch (e) {
        await _authRepository.refreshToken();
        await checkAuthState();
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> signOut() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser != null) {
        await _firestore.collection('users').doc(currentUser.uid).update({
          'fcmToken': null,
          'status': 'offline'
        });
        await FirebaseMessaging.instance.deleteToken();
      }
      await _auth.signOut();
      await LocalCache.setString(StringCache.accessToken, '');
      await LocalCache.setString(StringCache.refreshToken, '');
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  UserModel? getCurrentUser() {
    try {
      if (state is AuthAuthenticated) {
        return (state as AuthAuthenticated).user;
      }
      return null;
    } catch (e) {
      emit(AuthError(e.toString()));
      return null;
    }
  }

  void updateCurrentUser(UserModel user) {
    if (state is AuthAuthenticated) {
      emit(AuthAuthenticated(user));
    }
  }
}
