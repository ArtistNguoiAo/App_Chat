part of 'add_friend_cubit.dart';

@immutable
sealed class AddFriendState {}

final class AddFriendInitial extends AddFriendState {}

final class AddFriendLoading extends AddFriendState {}

final class AddFriendLoaded extends AddFriendState {
  final List<UserModel> listUser;
  final UserModel currentUser;

  AddFriendLoaded({
    required this.listUser,
    required this.currentUser,
  });
}

final class AddFriendError extends AddFriendState {
  final String message;

  AddFriendError({
    required this.message,
  });
}
