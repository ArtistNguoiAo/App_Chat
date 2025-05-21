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
  String get welcomeApp => 'Welcome to ChitChat!';

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

  @override
  String get updateProfile => 'Cập nhật hồ sơ';

  @override
  String get changePassword => 'Thay đổi mật khẩu';

  @override
  String get lightTheme => 'Sáng';

  @override
  String get darkTheme => 'Tối';

  @override
  String get firstNameRequired => 'Họ không được để trống';

  @override
  String get lastNameRequired => 'Tên không được để trống';

  @override
  String get profileUpdateSuccess => 'Cập nhật hồ sơ thành công';

  @override
  String get usernameRequired => 'Username không được để trống';

  @override
  String get passwordChangeSuccess => 'Đổi mật khẩu thành công';

  @override
  String get currentPassword => 'Mật khẩu hiện tại';

  @override
  String get currentPasswordRequired => 'Mật khẩu hiện tại không được để trống';

  @override
  String get newPassword => 'Mật khẩu mới';

  @override
  String get newPasswordRequired => 'Mật khẩu mới không được để trống';

  @override
  String get passwordTooShort => 'Mật khẩu phải có ít nhất 6 ký tự';

  @override
  String get confirmPasswordRequired => 'Xác nhận mật khẩu không được để trống';

  @override
  String get resetPassword => 'Đặt lại mật khẩu';

  @override
  String get resetPasswordEmailSent => 'Email đặt lại mật khẩu đã được gửi';

  @override
  String get enterEmail => 'Nhập email';

  @override
  String get forgotPasswordDescription => 'Nhập địa chỉ email của bạn và chúng tôi sẽ gửi cho bạn một liên kết để đặt lại mật khẩu của bạn.';

  @override
  String get forgotPassword => 'Quên mật khẩu?';

  @override
  String get emailRequired => 'Email không được để trống';

  @override
  String get passwordRequired => 'Mật khẩu không được để trống';

  @override
  String get recentChat => 'Trò chuyện gần đây';

  @override
  String get favoriteChat => 'Trò chuyện yêu thích';

  @override
  String get typeMessage => 'Nhập tin nhắn...';

  @override
  String get notify => 'Thông báo';

  @override
  String get notifyAcceptFriend => 'Bạn có lời mời kết bạn từ ';

  @override
  String get accept => 'Chấp nhận';

  @override
  String get cancel => 'Hủy bỏ';

  @override
  String get notRequestFriend => 'Không có lời mời kết bạn nào';

  @override
  String get message => 'Tin nhắn';

  @override
  String get pleaseChooseMin2Friends => 'Vui lòng chọn ít nhất 2 bạn bè';

  @override
  String get pleaseEnterGroupName => 'Vui lòng nhập tên nhóm';

  @override
  String get create => 'Tạo';

  @override
  String get chooseFriend => 'Chọn bạn bè';

  @override
  String get search => 'Tìm kiếm';

  @override
  String get groupName => 'Tên nhóm';

  @override
  String get createGroupSuccess => 'Tạo nhóm thành công';

  @override
  String get friend => 'Bạn bè';

  @override
  String get group => 'Nhóm';

  @override
  String get addFriend => 'Thêm bạn bè';

  @override
  String get addGroup => 'Thêm nhóm';

  @override
  String get deleteFriend => 'Xóa bạn bè';

  @override
  String get close => 'Đóng';

  @override
  String get requested => 'Đã yêu cầu';

  @override
  String get loading => 'Đang tải';

  @override
  String get errorLoginAuth => 'Đăng nhập không thành công, vui lòng kiểm tra lại thông tin tài khoản của bạn!';
}
