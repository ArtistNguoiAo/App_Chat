import 'package:app_chat/data/model/user_model.dart';
import 'package:app_chat/data/repository/auth_repository.dart';
import 'package:app_chat/data/repository/chat_repository.dart';
import 'package:app_chat/data/repository/message_repository.dart';
import 'package:app_chat/data/repository/user_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

part 'add_friend_state.dart';

class AddFriendCubit extends Cubit<AddFriendState> {
  AddFriendCubit() : super(AddFriendInitial());

  final AuthRepository _authRepository = GetIt.instance<AuthRepository>();
  final UserRepository _userRepository = GetIt.instance<UserRepository>();
  final ChatRepository _chatRepository = GetIt.instance<ChatRepository>();
  final MessageRepository _messageRepository = GetIt.instance<MessageRepository>();

  var listUser = <UserModel>[];

  Future<void> getListUser() async {
    emit(AddFriendLoading());
    try {
      listUser = await _authRepository.getAllUsers();
      final currentUser = await _authRepository.getCurrentUser();
      emit(AddFriendLoaded(listUser: listUser, currentUser: currentUser));
    } catch (e) {
      emit(AddFriendError(message: e.toString()));
    }
  }

  Future<void> searchUser(String query) async {
    final currentState = state as AddFriendLoaded;
    try {
      if(query.isEmpty) {
        emit(AddFriendLoaded(listUser: listUser, currentUser: currentState.currentUser));
      }
      else {
        final listUserTmp = listUser.where((user) {
          return user.fullName.toLowerCase().contains(query.toLowerCase()) ||
              user.username.toLowerCase().contains(query.toLowerCase());
        }).toList();
        emit(AddFriendLoaded(listUser: listUserTmp, currentUser: currentState.currentUser));
      }
    } catch (e) {
      emit(AddFriendError(message: e.toString()));
    }
  }

  Future<void> requestAddFriend(UserModel user) async {
    final currentState = state as AddFriendLoaded;
    try {
      currentState.currentUser.friendRequests.add(user.uid);
      await _userRepository.requestAddFriend(user);
      emit(AddFriendLoaded(listUser: currentState.listUser, currentUser: currentState.currentUser));
    } catch (e) {
      emit(AddFriendError(message: e.toString()));
      emit(currentState);
    }
  }

  Future<void> unRequestAddFriend(UserModel user) async {
    final currentState = state as AddFriendLoaded;
    try {
      currentState.currentUser.friendRequests.remove(user.uid);
      await _userRepository.unRequestAddFriend(user);
      emit(AddFriendLoaded(listUser: currentState.listUser, currentUser: currentState.currentUser));
    } catch (e) {
      emit(AddFriendError(message: e.toString()));
      emit(currentState);
    }
  }

  Future<void> deleteFriend(UserModel userModel) async {
    try {
      final currentUser = await _authRepository.getCurrentUser();
      final listChat = await _chatRepository.getAllChats();

      var chatId = '';
      for(var chat in listChat) {
        if (chat.members.contains(userModel.uid) && chat.members.contains(currentUser.uid) && chat.members.length == 2) {
          chatId = chat.id;
          break;
        }
      }

      await _messageRepository.deleteMessage(
        chatId: chatId,
      );
      await _chatRepository.deleteChat(
        chatId: chatId,
      );
      await _userRepository.deleteFriend(
        userModel: userModel,
      );

      final listUser = await _authRepository.getAllUsers();
      emit(AddFriendLoaded(listUser: listUser, currentUser: currentUser));
    } catch (e) {
      emit(AddFriendError(message: e.toString()));
    }
  }
}
