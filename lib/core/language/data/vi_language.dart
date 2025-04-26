import 'package:app_chat/core/language/data/base_language.dart';

class ViLanguage extends BaseLanguage {
  ViLanguage._();

  static final ViLanguage _instance = ViLanguage._();

  factory ViLanguage() => _instance;

  @override
  String get appName => 'ChitChat';

  @override
  String get login => 'Đăng nhập';

  @override
  String get register => 'Đăng ký';

  @override
  String get username => 'Tên đăng nhập';

  @override
  String get password => 'Mật khẩu';

  @override
  String get confirmPassword => 'Xác nhận mật khẩu';

  @override
  String get rememberMe => 'Ghi nhớ tài khoản';

  @override
  String get notHaveAnAccount => 'Chưa có tài khoản?';

  @override
  String get home => 'Trang chủ';

  @override
  String get profile => 'Hồ sơ';

  @override
  String get hello => 'Xin chào';

  @override
  String get haveAGoodDay => 'Chúc bạn một ngày tốt lành';

  @override
  String get welcomeApp => 'Chào mừng bạn đến với thế giới ChitChat!';

  @override
  String get introduceBot => "Tôi là trợ lý ảo CC_Bot. Tôi có thể giúp gì cho bạn?";

  @override
  String get language => 'Ngôn ngữ';

  @override
  String get theme => 'Chủ đề';

  @override
  String get firstName => 'Họ';

  @override
  String get lastName => 'Tên';

  @override
  String get accountManagement => 'Quản lý tài khoản';

  @override
  String get premiumAccount => 'Tài khoản VIP';

  @override
  String get changeLanguage => 'Thay đổi ngôn ngữ';

  @override
  String get logout => 'Đăng xuất';

  @override
  String get deleteAccount => 'Xóa tài khoản';

  @override
  String get cannotBeEmpty => 'Không được để trống';

  @override
  String get characters => 'ký tự';

  @override
  String get mustBeAtLeast => 'Phải có ít nhất';

  @override
  String get passwordsDoNotMatch => 'Mật khẩu không khớp';

  @override
  String get pleaseEnterValid => 'Vui lòng nhập đúng định dạng';

  @override
  String get registrationSuccessful => 'Đăng ký thành công';

  @override
  String get email => 'Email';
}