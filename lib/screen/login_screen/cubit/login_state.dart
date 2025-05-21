part of 'login_cubit.dart';

@immutable
sealed class LoginState {}

final class LoginInitial extends LoginState {}

final class LoginLoading extends LoginState {}

final class LoginLoaded extends LoginState {
  final String email;
  final String password;
  final bool rememberMe;

  LoginLoaded({
    required this.email,
    required this.password,
    required this.rememberMe,
  });
}

final class LoginSuccess extends LoginState {
  final UserModel user;
  final TokenModel tokens;

  LoginSuccess({required this.user, required this.tokens});
}

final class LoginError extends LoginState {
  final String error;

  LoginError({
    required this.error,
  });
}
