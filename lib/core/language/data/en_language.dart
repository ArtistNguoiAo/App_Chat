import 'package:app_chat/core/language/data/base_language.dart';

class EnLanguage extends BaseLanguage {
  EnLanguage._();

  static final EnLanguage _instance = EnLanguage._();

  factory EnLanguage() => _instance;

  @override
  String get appName => 'ChitChat';

  @override
  String get login => 'Login';

  @override
  String get register => 'Register';

  @override
  String get username => 'Username';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get rememberMe => 'Remember Me';

  @override
  String get notHaveAnAccount => 'Don\'t have an account?';

  @override
  String get home => 'Home';

  @override
  String get profile => 'Profile';

  @override
  String get hello => 'Hello';

  @override
  String get haveAGoodDay => 'Have a good day';

  @override
  String get welcomeApp => 'Welcome to ChitChat world!';

  @override
  String get introduceBot => "I'm virtual assistant CC_Bot. How can I help you?";

  @override
  String get language => 'Language';

  @override
  String get theme => 'Theme';

  @override
  String get firstName => 'First Name';

  @override
  String get lastName => 'Last Name';

  @override
  String get accountManagement => 'Account Management';

  @override
  String get premiumAccount => 'Premium Account';

  @override
  String get changeLanguage => 'Change Language';

  @override
  String get logout => 'Logout';

  @override
  String get deleteAccount => 'Delete Account';

  @override
  String get cannotBeEmpty => 'Cannot be empty';

  @override
  String get characters => 'characters';

  @override
  String get mustBeAtLeast => 'Must be at least';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get pleaseEnterValid => 'Please enter valid format';

  @override
  String get registrationSuccessful => 'Registration successful';

  @override
  String get email => 'Email';

  @override
  String get updateProfile => 'Update Profile';

  @override
  String get changePassword => 'Change Password';

  @override
  String get lightTheme => 'Light';

  @override
  String get darkTheme => 'Dark';
}