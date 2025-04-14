import 'package:app_chat/core/language/data/base_language.dart';

class ViLanguage extends BaseLanguage {
  ViLanguage._();

  static final ViLanguage _instance = ViLanguage._();

  factory ViLanguage() => _instance;

  @override
  String get login => 'Đăng nhập';
}