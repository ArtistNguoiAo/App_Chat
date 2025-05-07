import 'package:app_chat/data/model/user_model.dart';
import 'package:app_chat/data/repository/auth_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

part 'add_friend_state.dart';

class AddFriendCubit extends Cubit<AddFriendState> {
  AddFriendCubit() : super(AddFriendInitial());

  final AuthRepository _authRepository = GetIt.instance<AuthRepository>();

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
}
