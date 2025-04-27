import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repository/auth_repository.dart';

part 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final AuthRepository _authRepository;
  final BuildContext context;

  ForgotPasswordCubit(this.context)
      : _authRepository = AuthRepository(),
        super(ForgotPasswordInitial());

  Future<void> resetPassword(String email) async {
    try {
      emit(ForgotPasswordLoading());
      await _authRepository.forgotPassword(email);
      emit(ForgotPasswordSuccess());
    } catch (e) {
      emit(ForgotPasswordError(e.toString().replaceAll('Exception:', '').trim()));
    }
  }
}
