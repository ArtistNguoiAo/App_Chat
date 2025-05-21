import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

import '../../../data/repository/auth_repository.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final AuthRepository _authRepository = GetIt.instance<AuthRepository>();

  RegisterCubit() : super(RegisterInitial());

  Future<void> register({
    required String email,
    required String password,
    required String confirmPassword,
    required String username,
    required String firstName,
    required String lastName,
  }) async {
    emit(RegisterLoading());
    if(email.isEmpty || password.isEmpty || confirmPassword.isEmpty || username.isEmpty || firstName.isEmpty || lastName.isEmpty) {
      emit(RegisterError(error: 'All fields are required.'));
      return;
    }
    try {
      await _authRepository.registerUser(
        email: email,
        password: password,
        username: username,
        firstName: firstName,
        lastName: lastName,
      );
      emit(RegisterSuccess());
    } catch (e) {
      final message = e.toString();
      if (message.contains('email-already-in-use')) {
        emit(RegisterError(error: 'The email address is already in use by another account.'));
      } else {
        emit(RegisterError(error: 'Error: $message'));
      }
    }
  }
}
