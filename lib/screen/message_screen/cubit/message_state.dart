part of 'message_cubit.dart';

@immutable
sealed class MessageState {}

final class MessageInitial extends MessageState {}


class MessageLoaded extends MessageState {
  final List<MessageModel> listMessage;
  final UserModel currentUser;

  MessageLoaded({
    required this.listMessage,
    required this.currentUser,
  });
}