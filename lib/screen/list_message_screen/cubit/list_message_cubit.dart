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
  final AuthRepository _authRepository = GetIt.instance<AuthRepository>();
  final ChatRepository _chatRepository = GetIt.instance<ChatRepository>();

  ListMessageCubit() : super(ListMessageInitial());

  Future<void> getListUser() async {
    emit(ListMessageLoading());
    try {
      final listChat = await _chatRepository.getAllChats();
      final currentUser = await _authRepository.getCurrentUser();
      final listFriend = await _authRepository.getListFriend(currentUser);
      final listChatFriend = listChat.where((chat) => chat.type == 'private').toList();
      final listChatGroup = listChat.where((chat) => chat.type == 'group').toList();

      emit(ListMessageLoaded(
        listChatFriend: listChatFriend,
        listChatGroup: listChatGroup,
        listFriend: listFriend,
      ));
    } catch (e) {
      emit(ListMessageError(message: e.toString()));
    }
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
}
