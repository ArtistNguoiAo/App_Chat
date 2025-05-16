part of 'list_message_cubit.dart';

@immutable
sealed class ListMessageState {}

final class ListMessageInitial extends ListMessageState {}

final class ListMessageLoading extends ListMessageState {}

final class ListMessageLoaded extends ListMessageState {
  final List<UserModel> listUser;
  final UserModel currentUser;

  ListMessageLoaded({
    required this.listUser,
    required this.currentUser,
  });
}

final class ListMessageCreateGroupSuccess extends ListMessageState {}

final class ListMessageError extends ListMessageState {
  final String message;

  ListMessageError({
    required this.message,
  });
}