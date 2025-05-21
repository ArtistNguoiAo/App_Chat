import 'package:app_chat/core/ext_context/ext_context.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';

import '../../../data/repository/auth_repository.dart';

part 'change_password_state.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  final AuthRepository _authRepository = GetIt.instance<AuthRepository>();
  final BuildContext context;

  ChangePasswordCubit(this.context) : super(ChangePasswordInitial());

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      emit(ChangePasswordLoading());

      if (newPassword != confirmPassword) {
        throw Exception(context.language.passwordsDoNotMatch);
      }

      await _authRepository.changePassword(currentPassword, newPassword);
      emit(ChangePasswordSuccess());
    } catch (e) {
      emit(ChangePasswordError(e.toString().replaceAll('Exception:', '').trim()));
    }
  }
}
