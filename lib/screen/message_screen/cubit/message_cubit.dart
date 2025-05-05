import 'dart:async';
import 'package:app_chat/data/model/chat_model.dart';
import 'package:app_chat/data/model/message_model.dart';
import 'package:app_chat/data/repository/message_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

part 'message_state.dart';

class MessageCubit extends Cubit<MessageState> {
  StreamSubscription<List<MessageModel>>? _messageSubscription;

  MessageCubit() : super(MessageInitial());

  final MessageRepository _repository = GetIt.instance<MessageRepository>();

  void loadMessage({
    required List<String> seenBy,
  }) {
    _messageSubscription?.cancel();

    _messageSubscription = _repository.getMessage(seenBy).listen((listMessage) {
      emit(MessageLoaded(listMessage: listMessage));
    });
  }

  Future<void> sendMessage({
    required String userIdSend,
    required String text,
    required String createdAt,
    required List<String> seenBy,
  }) async {
    final messageModel = MessageModel(
      userIdSend: userIdSend,
      text: text,
      createdAt: createdAt,
      seenBy: seenBy,
    );

    await _repository.sendMessage(
      messageModel: messageModel,
    );
  }

  @override
  Future<void> close() {
    _messageSubscription?.cancel();
    return super.close();
  }
}
