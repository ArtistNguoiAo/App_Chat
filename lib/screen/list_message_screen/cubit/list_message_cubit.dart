import 'package:app_chat/data/model/user_model.dart';
import 'package:app_chat/data/repository/auth_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

part 'list_message_state.dart';

class ListMessageCubit extends Cubit<ListMessageState> {
  final AuthRepository _authRepository;

  ListMessageCubit() :
        _authRepository = GetIt.instance<AuthRepository>(),
        super(ListMessageInitial());

  Future<void> getListUser() async {
    emit(ListMessageLoading());
    try {
      // Simulate a network call
      final listUser = await _authRepository.getAllUsers();
      emit(ListMessageLoaded(listUser: listUser));
    } catch (e) {
      emit(ListMessageError(message: e.toString()));
    }
  }
}
