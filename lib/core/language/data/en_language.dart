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
  String get alreadyHaveAnAccount => 'Already have an account?';

  @override
  String get home => 'Home';

  @override
  String get profile => 'Profile';

  @override
  String get hello => 'Hello';

  @override
  String get haveAGoodDay => 'Have a good day';

  @override
  String get welcomeApp => 'Welcome to ChitChat!';

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

  @override
  String get firstNameRequired => 'First name cannot be empty';

  @override
  String get lastNameRequired => 'Last name cannot be empty';

  @override
  String get profileUpdateSuccess => 'Profile updated successfully';

  @override
  String get usernameRequired => 'Username cannot be empty';

  @override
  String get passwordChangeSuccess => 'Password changed successfully';

  @override
  String get currentPassword => 'Current Password';

  @override
  String get currentPasswordRequired => 'Current password cannot be empty';

  @override
  String get newPassword => 'New Password';

  @override
  String get newPasswordRequired => 'New password cannot be empty';

  @override
  String get passwordTooShort => 'Password must be at least 6 characters';

  @override
  String get confirmPasswordRequired => 'Confirm password cannot be empty';

  @override
  String get resetPassword => 'Reset Password';

  @override
  String get resetPasswordEmailSent => 'Reset password email sent';

  @override
  String get enterEmail => 'Enter your email';

  @override
  String get forgotPasswordDescription => 'Please enter your email to reset your password';

  @override
  String get forgotPassword => 'Forgot Password';

  @override
  String get emailRequired => 'Email cannot be empty';

  @override
  String get passwordRequired => 'Password cannot be empty';

  @override
  String get recentChat => 'Recent Chat';

  @override
  String get favoriteChat => 'Favorite Chat';

  @override
  String get typeMessage => 'Type a message...';

  @override
  String get notify => 'Notify';

  @override
  String get notifyAcceptFriend => 'You have a friend request from ';

  @override
  String get accept => 'Accept';

  @override
  String get cancel => 'Cancel';

  @override
  String get notRequestFriend => 'No friend requests yet';

  @override
  String get message => 'Message';

  @override
  String get pleaseChooseMin2Friends => 'Please choose at least 2 friends';

  @override
  String get pleaseEnterGroupName => 'Please enter group name';

  @override
  String get create => 'Create';

  @override
  String get chooseFriend => 'Choose friends';

  @override
  String get search => 'Search';

  @override
  String get groupName => 'Group Name';

  @override
  String get createGroupSuccess => 'Group created successfully';

  @override
  String get friend => 'Friend';

  @override
  String get group => 'Group';

  @override
  String get addFriend => 'Add Friend';

  @override
  String get addGroup => 'Add Group';

  @override
  String get deleteFriend => 'Delete Friend';

  @override
  String get close => 'Close';

  @override
  String get requested => 'Requested';

  @override
  String get loading => 'Loading';

  @override
  String get errorLoginAuth => 'Login failed, please check your email and password';

  @override
  String get logoutContent => 'Are you sure you want to log out?';

  @override
  String get noRecentChat => 'No recent chats yet';

  @override
  String get noFavoriteChat => 'No favorite chats yet';

  @override
  String get updateProfileContent => 'Are you sure you want to update your profile?';

  @override
  String get updatePasswordContent => 'Are you sure you want to update your password?';

  @override
  String get change => 'Change';

  @override
  String get updateProfileSuccessContent => 'Profile updated successfully';

  @override
  String get updatePasswordSuccessContent => 'Password updated successfully';

  @override
  String get delete => 'Delete';

  @override
  String get deleteFriendContent => 'Are you sure you want to delete this friend? This will also delete your chat with them?';

  @override
  String get selectImageSource => 'Select image source';

  @override
  String get pickFromGallery => 'Pick from gallery';

  @override
  String get takePhoto => 'Take photo';

  @override
  String get you => 'You';

  @override
  String get edit => 'Edit';

  @override
  String get save => 'Save';

  @override
  String get groupMembers => 'Group Members';

  @override
  String get yourQrCode => 'Your QR Code';
}
