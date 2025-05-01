import 'dart:io';

import 'package:bloc/bloc.dart';

import '../../../data/model/user_model.dart';
import '../../../data/repository/user_repository.dart';

part 'update_profile_state.dart';

class UpdateProfileCubit extends Cubit<UpdateProfileState> {
  final UserRepository _userRepository;

  UpdateProfileCubit()
      : _userRepository = UserRepository(),
        super(UpdateProfileInitial());

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

      emit(UpdateProfileSuccess(updatedUser));
    } catch (e) {
      emit(UpdateProfileError(e.toString()));
    }
  }
}
