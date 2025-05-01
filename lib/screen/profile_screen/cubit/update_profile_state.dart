part of 'update_profile_cubit.dart';

abstract class UpdateProfileState {}

class UpdateProfileInitial extends UpdateProfileState {}

class UpdateProfileLoading extends UpdateProfileState {}

class UpdateProfileSuccess extends UpdateProfileState {
  final UserModel user;

  UpdateProfileSuccess(this.user);
}

class UpdateProfileError extends UpdateProfileState {
  final String message;

  UpdateProfileError(this.message);
}
