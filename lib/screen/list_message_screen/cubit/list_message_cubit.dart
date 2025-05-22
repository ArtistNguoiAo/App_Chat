import 'dart:async';

import 'package:app_chat/data/model/chat_model.dart';
import 'package:app_chat/data/model/user_model.dart';
import 'package:app_chat/data/repository/auth_repository.dart';
import 'package:app_chat/data/repository/chat_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

part 'list_message_state.dart';

class ListMessageCubit extends Cubit<ListMessageState> {
  ListMessageCubit() : super(ListMessageInitial());

  StreamSubscription? _listFriendSubscription;
  final AuthRepository _authRepository = GetIt.instance<AuthRepository>();
  final ChatRepository _chatRepository = GetIt.instance<ChatRepository>();

  var listChatFriend = <ChatModel>[];
  var listChatGroup = <ChatModel>[];
  var listFriend = <UserModel>[];

  Future<void> getListUser() async {
    emit(ListMessageLoading());

    try {
      final listChat = await _chatRepository.getAllChats();
      final currentUser = await _authRepository.getCurrentUser();

      // Lọc danh sách chat riêng tư và nhóm
      listChatFriend = listChat.where((chat) => chat.type == 'private').toList();
      listChatGroup = listChat.where((chat) => chat.type == 'group').toList().where((chat) => chat.members.contains(currentUser.uid)).toList();

      // Hủy lắng nghe cũ nếu tồn tại
      _listFriendSubscription?.cancel();

      // Lắng nghe thay đổi bạn bè qua Stream
      _listFriendSubscription = _authRepository.getListFriendStream(currentUser).listen((listFriendStream) {
        listFriend = listFriendStream;
        if (!isClosed) {
          emit(ListMessageLoaded(
            listChatFriend: listChatFriend,
            listChatGroup: listChatGroup,
            listFriend: listFriendStream,
          ));
        }
      });
    } catch (e) {
      emit(ListMessageError(message: e.toString()));
    }
  }

  Future<void> searchFriend(String query) async {
    try {
      if (query.isEmpty) {
        emit(ListMessageLoaded(
          listChatFriend: listChatFriend,
          listChatGroup: listChatGroup,
          listFriend: listFriend,
        ));
      } else {
        final filteredListFriend = listFriend.where((user) {
          return user.fullName.toLowerCase().contains(query.toLowerCase());
        }).toList();
        emit(ListMessageLoaded(
          listChatFriend: listChatFriend,
          listChatGroup: listChatGroup,
          listFriend: filteredListFriend,
        ));
      }
    } catch (e) {
      emit(ListMessageError(message: e.toString()));
    }
  }

 Future<void> searchGroup(String query) async {
    try {
      if (query.isEmpty) {
        emit(ListMessageLoaded(
          listChatFriend: listChatFriend,
          listChatGroup: listChatGroup,
          listFriend: listFriend,
        ));
      } else {
        final filteredListGroup = listChatGroup.where((chat) {
          return chat.groupName.toLowerCase().contains(query.toLowerCase());
        }).toList();
        emit(ListMessageLoaded(
          listChatFriend: listChatFriend,
          listChatGroup: filteredListGroup,
          listFriend: listFriend,
        ));
      }
    } catch (e) {
      emit(ListMessageError(message: e.toString()));
    }
  }

  @override
  Future<void> close() {
    _listFriendSubscription?.cancel();
    return super.close();
  }


  Future<void> createGroup({
    required String groupName,
    required List<UserModel> listUser,
  }) async {
    final currentState = state as ListMessageLoaded;
    emit(ListMessageLoading());
    try {
      final currentUser = await _authRepository.getCurrentUser();
      final members = listUser.map((user) => user.uid).toList();
      members.add(currentUser.uid);

      await _chatRepository.addNewChat(
        members: members,
        groupName: groupName,
        groupAvatar: '',
        createdAt: DateFormat('yyyy-MM-dd hh:mm').format(DateTime.now()),
        lastMessageId: '',
      );
      emit(ListMessageCreateGroupSuccess());
      emit(currentState);
    } catch (e) {
      emit(ListMessageError(message: e.toString()));
    }
  }

  void dispose() {
    _listFriendSubscription?.cancel();
  }
}
