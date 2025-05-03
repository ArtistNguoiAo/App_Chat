part of 'list_message_cubit.dart';

@immutable
sealed class ListMessageState {}

final class ListMessageInitial extends ListMessageState {}

final class ListMessageLoading extends ListMessageState {}

final class ListMessageLoaded extends ListMessageState {
  final List<UserModel> listUser;

  ListMessageLoaded({
    required this.listUser,
  });
}

final class ListMessageError extends ListMessageState {
  final String message;

  ListMessageError({
    required this.message,
  });
}