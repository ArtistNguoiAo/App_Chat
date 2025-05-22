import 'dart:async';

import 'package:app_chat/data/model/chat_model.dart';
import 'package:app_chat/data/model/user_model.dart';
import 'package:app_chat/data/repository/auth_repository.dart';
import 'package:app_chat/data/repository/chat_repository.dart';
import 'package:app_chat/data/repository/message_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final AuthRepository _authRepository = GetIt.instance<AuthRepository>();
  final ChatRepository _chatRepository = GetIt.instance<ChatRepository>();
  final MessageRepository _messageRepository = GetIt.instance<MessageRepository>();
  StreamSubscription<List<ChatModel>>? _chatSubscription;
  Map<String, StreamSubscription<int>>? _messageCountSubscriptions;

  HomeCubit() : super(HomeInitial());

  @override
  Future<void> close() {
    _chatSubscription?.cancel();
    _messageCountSubscriptions?.values.forEach((sub) => sub.cancel());
    return super.close();
  }

  Future<void> loadHomeData() async {
    emit(HomeLoading());
    try {
      final currentUser = await _authRepository.getCurrentUser();
      final allUsersList = await _authRepository.getAllUsers();
      final allUsersMap = {for (var u in allUsersList) u.uid: u};
      allUsersMap[currentUser.uid] = currentUser;

      // Listen to user's chats
      _chatSubscription?.cancel();
      _chatSubscription = _chatRepository.streamUserChats(currentUser.uid).listen((allChatsSystem) async {
        final currentUserChats = allChatsSystem;

        // Sort by lastMessageTime (descending)
        final recentChats = currentUserChats.take(10).toList();

        // Setup message count subscriptions for favorite chats
        _messageCountSubscriptions?.values.forEach((sub) => sub.cancel());
        _messageCountSubscriptions = {};

        Map<ChatModel, int> chatMessageCounts = {};
        for (final chat in currentUserChats) {
          try {
            final count = await _messageRepository.getMessagesCountInChat(chat.id);
            chatMessageCounts[chat] = count;
          } catch (e) {
            chatMessageCounts[chat] = 0;
          }
        }

        List<MapEntry<ChatModel, int>> sortedChatEntries = chatMessageCounts.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

        final favoriteChats = sortedChatEntries.map((entry) => entry.key).take(3).toList();

        emit(HomeLoaded(
          currentUser: currentUser,
          recentChats: recentChats,
          favoriteChats: favoriteChats,
          allUsersMap: allUsersMap,
        ));
      });
    } catch (e) {
      emit(HomeError(message: 'Failed to load home data: $e'));
    }
  }
}
