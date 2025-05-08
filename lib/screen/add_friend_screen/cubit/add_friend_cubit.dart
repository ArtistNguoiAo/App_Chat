import 'package:app_chat/data/model/user_model.dart';
import 'package:app_chat/data/repository/auth_repository.dart';
import 'package:app_chat/data/repository/user_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

part 'add_friend_state.dart';

class AddFriendCubit extends Cubit<AddFriendState> {
  AddFriendCubit() : super(AddFriendInitial());

  final AuthRepository _authRepository = GetIt.instance<AuthRepository>();
  final UserRepository _userRepository = GetIt.instance<UserRepository>();

  Future<void> getListUser() async {
    emit(AddFriendLoading());
    try {
      final listUser = await _authRepository.getAllUsers();
      final currentUser = await _authRepository.getCurrentUser();
      emit(AddFriendLoaded(listUser: listUser, currentUser: currentUser));
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
    }
  }
}
