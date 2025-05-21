import 'package:app_chat/core/ext_context/ext_context.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

import '../../../data/local_cache.dart';
import '../../../data/model/token_model.dart';
import '../../../data/model/user_model.dart';
import '../../../data/repository/auth_repository.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _authRepository = GetIt.instance<AuthRepository>();

  LoginCubit() : super(LoginInitial());

  Future<void> init() async {
    final rememberMe = await LocalCache.getBool(StringCache.rememberMe);
    final email = await LocalCache.getString(StringCache.email);
    final password = await LocalCache.getString(StringCache.password);
    try {
      emit(LoginLoaded(
        email: email,
        password: password,
        rememberMe: rememberMe,
      ));
    } catch (e) {
      emit(LoginError(error: e.toString()));
    }
  }

  Future<void> login({
    required String email,
    required String password,
    required bool rememberMe,
  }) async {
    emit(LoginLoading());
    try {
      if (rememberMe) {
        await LocalCache.setString(StringCache.email, email);
        await LocalCache.setString(StringCache.password, password);
        await LocalCache.setBool(StringCache.rememberMe, true);
      }
      else {
        await LocalCache.setString(StringCache.email, '');
        await LocalCache.setString(StringCache.password, '');
        await LocalCache.setBool(StringCache.rememberMe, false);
      }

      await _authRepository.loginUser(
        email: email,
        password: password,
      );

      final (user, tokens) = await _authRepository.loginUser(
        email: email,
        password: password,
      );

      emit(LoginSuccess(user: user, tokens: tokens));
    } catch (e) {
      final message = e.toString();
      if (message.contains('invalid-credential')) {
        emit(LoginError(error: 'Login failed, please check your email and password'));
      } else {
        emit(LoginError(error: 'Error: $message'));
      }
      emit(LoginLoaded(
        email: email,
        password: password,
        rememberMe: rememberMe,
      ));
    }
  }
}
