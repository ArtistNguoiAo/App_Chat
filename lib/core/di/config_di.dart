import 'package:app_chat/data/repository/message_repository.dart';
import 'package:app_chat/data/repository/user_repository.dart';
import 'package:get_it/get_it.dart';

import '../../data/repository/auth_repository.dart';

class ConfigDI {
  static final ConfigDI _singleton = ConfigDI._internal();

  factory ConfigDI() {
    return _singleton;
  }

  ConfigDI._internal(){
    // Register your dependencies here
    injector.registerLazySingleton<AuthRepository>(() => AuthRepository());
    injector.registerLazySingleton<MessageRepository>(() => MessageRepository());
    injector.registerLazySingleton<UserRepository>(() => UserRepository());
  }

  GetIt injector = GetIt.instance;
}