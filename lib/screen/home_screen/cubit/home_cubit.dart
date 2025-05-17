import 'package:app_chat/data/model/chat_model.dart';
import 'package:app_chat/data/model/user_model.dart';
import 'package:app_chat/data/repository/auth_repository.dart';
import 'package:app_chat/data/repository/chat_repository.dart';
import 'package:app_chat/data/repository/message_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart'; // Required for DateFormat
import 'package:meta/meta.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final AuthRepository _authRepository = GetIt.instance<AuthRepository>();
  final ChatRepository _chatRepository = GetIt.instance<ChatRepository>();
  final MessageRepository _messageRepository = GetIt.instance<MessageRepository>();

  HomeCubit() : super(HomeInitial());

  Future<void> loadHomeData() async {
    try {
      emit(HomeLoading());

      final currentUser = await _authRepository.getCurrentUser();
      final allUsersList = await _authRepository.getAllUsers();
      final allUsersMap = {for (var u in allUsersList) u.uid: u};
      allUsersMap[currentUser.uid] = currentUser; // Add current user for convenience

      final allChatsSystem = await _chatRepository.getAllChats();
      final currentUserChats = allChatsSystem
          .where((chat) => chat.members.contains(currentUser.uid))
          .toList();

      // Recent Chats (top 10 by ChatModel.createdAt)
      // Assuming createdAt is in 'dd-MM-yyyy HH:mm:ss' format
      final dateFormat = DateFormat('dd-MM-yyyy HH:mm:ss');
      currentUserChats.sort((a, b) {
        try {
          final dateA = dateFormat.parse(a.createdAt);
          final dateB = dateFormat.parse(b.createdAt);
          return dateB.compareTo(dateA); // Descending for most recent
        } catch (e) {
          print('Error parsing createdAt dates for sorting recent chats: $e. Chat A: ${a.createdAt}, Chat B: ${b.createdAt}');
          return b.createdAt.compareTo(a.createdAt); // Fallback to string sort
        }
      });
      final recentChats = currentUserChats.take(10).toList();

      // Favorite Chats (top 3 chats with the most messages)
      Map<ChatModel, int> chatMessageCounts = {};
      for (final chat in currentUserChats) {
        try {
          // Use the new repository method to get message count directly
          final count = await _messageRepository.getMessagesCountInChat(chat.id);
          chatMessageCounts[chat] = count;
        } catch (e) {
          chatMessageCounts[chat] = 0;
          print('Error fetching messages count for chat ${chat.id} for favorites: $e');
        }
      }

      // Sort chats by message count in descending order
      List<MapEntry<ChatModel, int>> sortedChatEntries = chatMessageCounts.entries
          .toList()
        ..sort((a, b) => b.value.compareTo(a.value));

      // Take the top 3 chats as favorites
      final favoriteChats = sortedChatEntries
          .map((entry) => entry.key) // Extract ChatModel from MapEntry
          .take(3)
          .toList();

      emit(HomeLoaded(
        currentUser: currentUser,
        recentChats: recentChats,
        favoriteChats: favoriteChats,
        allUsersMap: allUsersMap,
      ));
    } catch (e, stackTrace) {
      print('Error in loadHomeData: $e\n$stackTrace');
      emit(HomeError(message: 'Failed to load home data: $e'));
    }
  }
}
