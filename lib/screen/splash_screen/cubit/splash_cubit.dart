import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashInitial());

  Future<void> init() async {
    emit(SplashLoaded());
    await Future.delayed(const Duration(milliseconds: 3000));
    emit(SplashSuccess());
  }
}
