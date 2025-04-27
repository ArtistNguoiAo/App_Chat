import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

import '../../../data/local_cache.dart';
import '../../../data/model/token_model.dart';
import '../../../data/model/user_model.dart';
import '../../../data/repository/auth_repository.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _authRepository;

  LoginCubit()
      : _authRepository = GetIt.instance<AuthRepository>(),
        super(LoginInitial());

  Future<void> login({
    required String email,
    required String password,
    required bool rememberMe,
  }) async {
    emit(LoginLoading());

    try {
      final (user, tokens) = await _authRepository.loginUser(
        email: email,
        password: password,
      );

      if (rememberMe) {
        await LocalCache.setString(StringCache.email, email);
        await LocalCache.setString(StringCache.password, password);
        await LocalCache.setBool(StringCache.rememberMe, true);
      }

      emit(LoginSuccess(user: user, tokens: tokens));
    } catch (e) {
      emit(LoginFailure(e.toString()));
    }
  }
}
