import 'package:app_chat/data/model/user_model.dart';
import 'package:app_chat/data/repository/auth_repository.dart';
import 'package:app_chat/data/repository/chat_repository.dart';
import 'package:app_chat/data/repository/user_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

part 'notify_state.dart';

class NotifyCubit extends Cubit<NotifyState> {
  NotifyCubit() : super(NotifyInitial());

  final AuthRepository _authRepository = GetIt.instance<AuthRepository>();
  final UserRepository _userRepository = GetIt.instance<UserRepository>();
  final ChatRepository _chatRepository = GetIt.instance<ChatRepository>();

  Future<void> getListNotify() async {
    emit(NotifyLoading());
    try {
      final listUser = await _authRepository.getAllUsers();
      final currentUser = await _authRepository.getCurrentUser();
      final listUserFinal = listUser.where((user) => currentUser.friendRequests.contains(user.uid)).toList();
      emit(NotifyLoaded(listUser: listUserFinal, currentUser: currentUser));
    } catch (e) {
      emit(NotifyError(message: e.toString()));
    }
  }

  Future<void> acceptRequest(UserModel user, bool check) async {
    final currentState = state as NotifyLoaded;
    try {
      currentState.currentUser.friends.add(user.uid);
      await _userRepository.acceptFriend(user, check);
      await _chatRepository.addNewCha(
        members: [currentState.currentUser.uid, user.uid],
        groupName: user.username,
        groupAvatar: user.avatar,
        createdAt: DateFormat('yyyy-MM-dd – hh:mm').format(DateTime.now()),
        lastMessageId: '',
      );
      emit(NotifyLoaded(listUser: currentState.listUser, currentUser: currentState.currentUser));
    } catch (e) {
      emit(NotifyError(message: e.toString()));
    }
  }
}
