import 'package:get_it/get_it.dart';

class ConfigDI {
  static final ConfigDI _singleton = ConfigDI._internal();

  factory ConfigDI() {
    return _singleton;
  }

  ConfigDI._internal();

  GetIt injector = GetIt.instance;
}