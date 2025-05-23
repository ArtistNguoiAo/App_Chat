import 'dart:async';

import 'package:app_chat/data/model/chat_model.dart';
import 'package:app_chat/data/model/user_model.dart';
import 'package:app_chat/data/repository/auth_repository.dart';
import 'package:app_chat/data/repository/chat_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

part 'list_message_state.dart';

class ListMessageCubit extends Cubit<ListMessageState> {
  ListMessageCubit() : super(ListMessageInitial());

  StreamSubscription? _listFriendSubscription;
  StreamSubscription? _friendChatSubscription;
  StreamSubscription? _groupChatSubscription;
  final AuthRepository _authRepository = GetIt.instance<AuthRepository>();
  final ChatRepository _chatRepository = GetIt.instance<ChatRepository>();
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  var listChatFriend = <ChatModel>[];
  var listChatGroup = <ChatModel>[];
  var listFriend = <UserModel>[];
  var mapFriend = <String, UserModel>{};
  var currentUser;

  Future<void> getListUser() async {
    emit(ListMessageLoading());

    try {
      currentUser = await _authRepository.getCurrentUser();
      final allUsers = await _authRepository.getAllUsers();
      // Cancel old subscriptions if exist
      _friendChatSubscription?.cancel();
      _groupChatSubscription?.cancel();
      _listFriendSubscription?.cancel();

      // Stream friend (private) chats
      _friendChatSubscription = _chatRepository.streamUserChats(currentUser.uid).listen((chats) {
        listChatFriend = chats.where((chat) => chat.type == 'private').toList();
        var listFriend = <UserModel>[];
        for (var chat in listChatFriend) {
          final otherUserId = chat.members.firstWhere((id) => id != currentUser.uid);
          final otherUser = allUsers.firstWhere((user) => user.uid == otherUserId);
          mapFriend[chat.id] = otherUser;
          listFriend.add(otherUser);
        }

        if (!isClosed) {
          emit(ListMessageLoaded(
            listChatFriend: listChatFriend,
            listChatGroup: listChatGroup,
            listFriend: listFriend,
            mapFriend: mapFriend,
            currentUser: currentUser,
          ));
        }
      });

      // Stream group chats
      _groupChatSubscription = _chatRepository.streamUserChats(currentUser.uid).listen((chats) {
        listChatGroup = chats.where((chat) => chat.type == 'group').toList();
        if (!isClosed) {
          emit(ListMessageLoaded(
            listChatFriend: listChatFriend,
            listChatGroup: listChatGroup,
            listFriend: listFriend,
            mapFriend: mapFriend,
            currentUser: currentUser,
          ));
        }
      });

      // Stream users collection and filter by friends list
      _listFriendSubscription = _fireStore.collection('users').snapshots().listen((snapshot) {
        final allUsers = snapshot.docs.map((doc) => UserModel.fromMap(doc.data())).toList();
        final curUser = allUsers.firstWhere((user) => user.uid == currentUser.uid);
        listFriend = allUsers.where((user) => curUser.friends.contains(user.uid)).toList();
        print('listFriend: $listFriend');
        if (!isClosed) {
          emit(ListMessageLoaded(
            listChatFriend: listChatFriend,
            listChatGroup: listChatGroup,
            listFriend: listFriend,
            mapFriend: mapFriend,
            currentUser: curUser,
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
          mapFriend: mapFriend,
          currentUser: currentUser,
        ));
      } else {
        final filteredMapFriend = Map<String, UserModel>.from(mapFriend)..removeWhere((_, user) => !user.fullName.toLowerCase().contains(query.toLowerCase()));

        emit(ListMessageLoaded(
          listChatFriend: listChatFriend,
          listChatGroup: listChatGroup,
          listFriend: filteredMapFriend.values.toList(),
          mapFriend: filteredMapFriend,
          currentUser: currentUser,
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
          mapFriend: mapFriend,
          currentUser: currentUser,
        ));
      } else {
        final filteredListGroup = listChatGroup.where((chat) {
          return chat.groupName.toLowerCase().contains(query.toLowerCase());
        }).toList();
        emit(ListMessageLoaded(
          listChatFriend: listChatFriend,
          listChatGroup: filteredListGroup,
          listFriend: listFriend,
          mapFriend: mapFriend,
          currentUser: currentUser,
        ));
      }
    } catch (e) {
      emit(ListMessageError(message: e.toString()));
    }
  }

  @override
  Future<void> close() {
    _listFriendSubscription?.cancel();
    _friendChatSubscription?.cancel();
    _groupChatSubscription?.cancel();
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
        createdAt: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
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
