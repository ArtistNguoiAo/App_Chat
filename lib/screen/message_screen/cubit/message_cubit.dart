import 'dart:async';
import 'dart:io';
import 'package:app_chat/core/utils/cloudinary_utils.dart';
import 'package:app_chat/data/model/chat_model.dart';
import 'package:app_chat/data/model/message_model.dart';
import 'package:app_chat/data/model/user_model.dart';
import 'package:app_chat/data/repository/auth_repository.dart';
import 'package:app_chat/data/repository/chat_repository.dart';
import 'package:app_chat/data/repository/message_repository.dart';
import 'package:app_chat/data/repository/user_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

part 'message_state.dart';

class MessageCubit extends Cubit<MessageState> {
  MessageCubit() : super(MessageInitial());

  StreamSubscription<List<MessageModel>>? _messageSubscription;
  final AuthRepository _authRepository = GetIt.instance<AuthRepository>();
  final CloudinaryUtils _cloudinary = CloudinaryUtils();
  final MessageRepository _messageRepository = GetIt.instance<MessageRepository>();
  final ChatRepository _chatRepository = GetIt.instance<ChatRepository>();
  final UserRepository _userRepository = GetIt.instance<UserRepository>();

  Future<void> loadMessage({
    required List<String> seenBy,
    required String chatId,
  }) async {
    _messageSubscription?.cancel();

    final currentUser = await _authRepository.getCurrentUser();

    _messageSubscription = _messageRepository.getMessage(
      chatId: chatId,
      targetSeenBy: seenBy,
    ).listen((listMessage) {
      emit(MessageLoaded(listMessage: listMessage, currentUser: currentUser));
    });
  }

  Future<void> sendMessage({
    required String userIdSend,
    required String userAvatarSend,
    required String userNameSend,
    required String text,
    required String createdAt,
    required List<String> seenBy,
    required String chatId,
    required String type,
    File? imageFile,
  }) async {

    if(imageFile != null) {
      final uploadedUrl = await _cloudinary.uploadFile(imageFile, 'messages');
      if (uploadedUrl != null) {
        text = uploadedUrl;
        type = 'image';
      }
    }
    final messageModel = MessageModel(
      id: '',
      userIdSend: userIdSend,
      userAvatarSend: userAvatarSend,
      text: text,
      createdAt: createdAt,
      seenBy: seenBy,
      type: type,
    );

    await _chatRepository.updateChat(
      chatId: chatId,
      lastMessage: text,
      lastMessageSenderId: userIdSend,
      lastMessageSenderName: userNameSend,
    );

    await _messageRepository.sendMessageWithNotification(
      messageModel: messageModel,
      chatId: chatId,
    );
  }

  Future<void> deleteFriend({
    required UserModel userModel,
    required String chatId,
  }) async {
    await _messageRepository.deleteMessage(
      chatId: chatId,
    );
    await _chatRepository.deleteChat(
      chatId: chatId,
    );
    await _userRepository.deleteFriend(
      userModel: userModel,
    );
    emit(MessageDeleteSuccess());
  }

  Future<void> updateGroup({
    required String chatId,
    required String groupName,
    File? groupAvatar,
  }) async {
    await _chatRepository.updateChat(
      chatId: chatId,
      groupName: groupName,
      groupAvatar: groupAvatar,
    );


  }

  @override
  Future<void> close() {
    _messageSubscription?.cancel();
    return super.close();
  }
}
