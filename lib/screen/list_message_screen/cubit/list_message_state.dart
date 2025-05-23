part of 'list_message_cubit.dart';

@immutable
sealed class ListMessageState {}

final class ListMessageInitial extends ListMessageState {}

final class ListMessageLoading extends ListMessageState {}

final class ListMessageLoaded extends ListMessageState {
  final List<ChatModel> listChatFriend;
  final List<ChatModel> listChatGroup;
  final List<UserModel> listFriend;
  final UserModel currentUser;

  ListMessageLoaded({
    required this.listChatFriend,
    required this.listChatGroup,
    required this.listFriend,
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