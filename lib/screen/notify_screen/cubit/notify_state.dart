part of 'notify_cubit.dart';

@immutable
sealed class NotifyState {}

final class NotifyInitial extends NotifyState {}

final class NotifyLoading extends NotifyState {}

final class NotifyLoaded extends NotifyState {
  final List<UserModel> listUser;
  final UserModel currentUser;

  NotifyLoaded({
    required this.listUser,
    required this.currentUser,
  });
}

final class NotifyError extends NotifyState {
  final String message;

  NotifyError({
    required this.message,
  });
}