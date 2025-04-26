import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

import '../../../data/model/UserModel.dart';
import '../../../data/repository/AuthRepository.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  AuthCubit()
      : _authRepository = GetIt.instance<AuthRepository>(),
        _auth = FirebaseAuth.instance,
        _firestore = FirebaseFirestore.instance,
        super(AuthInitial());

  Future<void> checkAuthState() async {
    emit(AuthLoading());
    try {
      final currentUser = _auth.currentUser;
      if (currentUser != null) {
        final userDoc = await _firestore
            .collection('users')
            .doc(currentUser.uid)
            .get();

        if (userDoc.exists) {
          emit(AuthAuthenticated(UserModel.fromMap(userDoc.data()!)));
        } else {
          emit(AuthUnauthenticated());
        }
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
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
}