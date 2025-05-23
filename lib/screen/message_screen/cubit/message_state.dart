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

class MessageDeleteSuccess extends MessageState {}

class MessageUpdateGroupSuccess extends MessageState {
  final String groupName;
  final String groupAvatar;
  final List<MessageModel> listMessage;
  final UserModel currentUser;

  MessageUpdateGroupSuccess({
    required this.groupName,
    required this.groupAvatar,
    required this.listMessage,
    required this.currentUser,
  });
}