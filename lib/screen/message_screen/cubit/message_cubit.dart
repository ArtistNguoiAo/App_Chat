import 'package:app_chat/data/model/message_model.dart';
import 'package:app_chat/data/repository/message_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

part 'message_state.dart';

class MessageCubit extends Cubit<MessageState> {
  final MessageRepository _repository;

  MessageCubit()
      : _repository = GetIt.instance<MessageRepository>(),
        super(MessageInitial());

  void loadMessage({
    required String userIdFrom,
    required String userIdTo,
  }) {
    _repository.getMessages(userIdFrom, userIdTo).listen((listMessage) {
      emit(MessageLoaded(listMessage: listMessage));
    });
  }


  Future<void> sendMessage({
    required String userIdFrom,
    required String userIdTo,
    required String text,
  }) async {
    await _repository.sendMessage(
      MessageModel(
        userIdFrom: userIdFrom,
        userIdTo: userIdTo,
        text: text,
        createdAt: DateTime.now().toString(),
      ),
    );
  }
}

