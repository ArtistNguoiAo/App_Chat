import 'dart:io';

import 'package:app_chat/data/repository/auth_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../data/model/user_model.dart';
import '../../../data/repository/user_repository.dart';

part 'update_profile_state.dart';

class UpdateProfileCubit extends Cubit<UpdateProfileState> {
  final UserRepository _userRepository  = GetIt.instance<UserRepository>();

  UpdateProfileCubit() : super(UpdateProfileInitial());

  Future<void> updateProfile({
    required UserModel user,
    required String username,
    required String firstName,
    required String lastName,
    File? imageFile,
  }) async {
    try {
      emit(UpdateProfileLoading());

      final updatedUser = await _userRepository.updateProfile(
        user: user,
        username: username,
        firstName: firstName,
        lastName: lastName,
        imageFile: imageFile,
      );

      emit(UpdateProfileSuccess(user: updatedUser));
    } catch (e) {
      emit(UpdateProfileError(e.toString()));
    }
  }
}
