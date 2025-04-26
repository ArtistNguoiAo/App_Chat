import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

import '../../../data/repository/AuthRepository.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final AuthRepository _authRepository;

  RegisterCubit()
      : _authRepository = GetIt.instance<AuthRepository>(),
        super(RegisterInitial());

  Future<void> register({
    required String email,
    required String password,
    required String username,
    required String firstName,
    required String lastName,
  }) async {
    emit(RegisterLoading());

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
      emit(RegisterFailure(e.toString()));
    }
  }
}
