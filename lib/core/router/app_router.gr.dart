// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:app_chat/core/widget/qr_scanner_screen.dart' as _i12;
import 'package:app_chat/data/model/chat_model.dart' as _i19;
import 'package:app_chat/data/model/user_model.dart' as _i20;
import 'package:app_chat/screen/add_friend_screen/add_friend_screen.dart'
    as _i1;
import 'package:app_chat/screen/home_screen/home_screen.dart' as _i4;
import 'package:app_chat/screen/list_message_screen/list_message_screen.dart'
    as _i6;
import 'package:app_chat/screen/login_screen/forgot_password_screen.dart'
    as _i3;
import 'package:app_chat/screen/login_screen/login_screen.dart' as _i7;
import 'package:app_chat/screen/message_screen/message_screen.dart' as _i8;
import 'package:app_chat/screen/notify_screen/notify_screen.dart' as _i9;
import 'package:app_chat/screen/over_view_screen/over_view_screen.dart' as _i10;
import 'package:app_chat/screen/profile_screen/change_password_screen.dart'
    as _i2;
import 'package:app_chat/screen/profile_screen/language_setting_screen.dart'
    as _i5;
import 'package:app_chat/screen/profile_screen/profile_screen.dart' as _i11;
import 'package:app_chat/screen/profile_screen/theme_setting_screen.dart'
    as _i15;
import 'package:app_chat/screen/profile_screen/update_profile_screen.dart'
    as _i16;
import 'package:app_chat/screen/register_screen/register_screen.dart' as _i13;
import 'package:app_chat/screen/splash_screen/splash_screen.dart' as _i14;
import 'package:auto_route/auto_route.dart' as _i17;
import 'package:flutter/material.dart' as _i18;

abstract class $AppRouter extends _i17.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i17.PageFactory> pagesMap = {
    AddFriendRoute.name: (routeData) {
      final args = routeData.argsAs<AddFriendRouteArgs>(
          orElse: () => const AddFriendRouteArgs());
      return _i17.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i1.AddFriendScreen(key: args.key),
      );
    },
    ChangePasswordRoute.name: (routeData) {
      return _i17.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i2.ChangePasswordScreen(),
      );
    },
    ForgotPasswordRoute.name: (routeData) {
      return _i17.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i3.ForgotPasswordScreen(),
      );
    },
    HomeRoute.name: (routeData) {
      return _i17.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i4.HomeScreen(),
      );
    },
    LanguageSettingRoute.name: (routeData) {
      return _i17.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i5.LanguageSettingScreen(),
      );
    },
    ListMessageRoute.name: (routeData) {
      return _i17.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i6.ListMessageScreen(),
      );
    },
    LoginRoute.name: (routeData) {
      return _i17.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i7.LoginScreen(),
      );
    },
    MessageRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<MessageRouteArgs>(
          orElse: () =>
              MessageRouteArgs(chatId: pathParams.optString('chatId')));
      return _i17.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i8.MessageScreen(
          key: args.key,
          chatId: args.chatId,
          chatModel: args.chatModel,
          friend: args.friend,
        ),
      );
    },
    NotifyRoute.name: (routeData) {
      return _i17.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i9.NotifyScreen(),
      );
    },
    OverViewRoute.name: (routeData) {
      return _i17.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i10.OverViewScreen(),
      );
    },
    ProfileRoute.name: (routeData) {
      return _i17.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i11.ProfileScreen(),
      );
    },
    QrScannerRoute.name: (routeData) {
      return _i17.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i12.QrScannerScreen(),
      );
    },
    RegisterRoute.name: (routeData) {
      return _i17.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i13.RegisterScreen(),
      );
    },
    SplashRoute.name: (routeData) {
      return _i17.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i14.SplashScreen(),
      );
    },
    ThemeSettingRoute.name: (routeData) {
      return _i17.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i15.ThemeSettingScreen(),
      );
    },
    UpdateProfileRoute.name: (routeData) {
      final args = routeData.argsAs<UpdateProfileRouteArgs>();
      return _i17.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i16.UpdateProfileScreen(
          key: args.key,
          user: args.user,
        ),
      );
    },
  };
}

/// generated route for
/// [_i1.AddFriendScreen]
class AddFriendRoute extends _i17.PageRouteInfo<AddFriendRouteArgs> {
  AddFriendRoute({
    _i18.Key? key,
    List<_i17.PageRouteInfo>? children,
  }) : super(
          AddFriendRoute.name,
          args: AddFriendRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'AddFriendRoute';

  static const _i17.PageInfo<AddFriendRouteArgs> page =
      _i17.PageInfo<AddFriendRouteArgs>(name);
}

class AddFriendRouteArgs {
  const AddFriendRouteArgs({this.key});

  final _i18.Key? key;

  @override
  String toString() {
    return 'AddFriendRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i2.ChangePasswordScreen]
class ChangePasswordRoute extends _i17.PageRouteInfo<void> {
  const ChangePasswordRoute({List<_i17.PageRouteInfo>? children})
      : super(
          ChangePasswordRoute.name,
          initialChildren: children,
        );

  static const String name = 'ChangePasswordRoute';

  static const _i17.PageInfo<void> page = _i17.PageInfo<void>(name);
}

/// generated route for
/// [_i3.ForgotPasswordScreen]
class ForgotPasswordRoute extends _i17.PageRouteInfo<void> {
  const ForgotPasswordRoute({List<_i17.PageRouteInfo>? children})
      : super(
          ForgotPasswordRoute.name,
          initialChildren: children,
        );

  static const String name = 'ForgotPasswordRoute';

  static const _i17.PageInfo<void> page = _i17.PageInfo<void>(name);
}

/// generated route for
/// [_i4.HomeScreen]
class HomeRoute extends _i17.PageRouteInfo<void> {
  const HomeRoute({List<_i17.PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static const _i17.PageInfo<void> page = _i17.PageInfo<void>(name);
}

/// generated route for
/// [_i5.LanguageSettingScreen]
class LanguageSettingRoute extends _i17.PageRouteInfo<void> {
  const LanguageSettingRoute({List<_i17.PageRouteInfo>? children})
      : super(
          LanguageSettingRoute.name,
          initialChildren: children,
        );

  static const String name = 'LanguageSettingRoute';

  static const _i17.PageInfo<void> page = _i17.PageInfo<void>(name);
}

/// generated route for
/// [_i6.ListMessageScreen]
class ListMessageRoute extends _i17.PageRouteInfo<void> {
  const ListMessageRoute({List<_i17.PageRouteInfo>? children})
      : super(
          ListMessageRoute.name,
          initialChildren: children,
        );

  static const String name = 'ListMessageRoute';

  static const _i17.PageInfo<void> page = _i17.PageInfo<void>(name);
}

/// generated route for
/// [_i7.LoginScreen]
class LoginRoute extends _i17.PageRouteInfo<void> {
  const LoginRoute({List<_i17.PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static const _i17.PageInfo<void> page = _i17.PageInfo<void>(name);
}

/// generated route for
/// [_i8.MessageScreen]
class MessageRoute extends _i17.PageRouteInfo<MessageRouteArgs> {
  MessageRoute({
    _i18.Key? key,
    String? chatId,
    _i19.ChatModel? chatModel,
    _i20.UserModel? friend,
    List<_i17.PageRouteInfo>? children,
  }) : super(
          MessageRoute.name,
          args: MessageRouteArgs(
            key: key,
            chatId: chatId,
            chatModel: chatModel,
            friend: friend,
          ),
          rawPathParams: {'chatId': chatId},
          initialChildren: children,
        );

  static const String name = 'MessageRoute';

  static const _i17.PageInfo<MessageRouteArgs> page =
      _i17.PageInfo<MessageRouteArgs>(name);
}

class MessageRouteArgs {
  const MessageRouteArgs({
    this.key,
    this.chatId,
    this.chatModel,
    this.friend,
  });

  final _i18.Key? key;

  final String? chatId;

  final _i19.ChatModel? chatModel;

  final _i20.UserModel? friend;

  @override
  String toString() {
    return 'MessageRouteArgs{key: $key, chatId: $chatId, chatModel: $chatModel, friend: $friend}';
  }
}

/// generated route for
/// [_i9.NotifyScreen]
class NotifyRoute extends _i17.PageRouteInfo<void> {
  const NotifyRoute({List<_i17.PageRouteInfo>? children})
      : super(
          NotifyRoute.name,
          initialChildren: children,
        );

  static const String name = 'NotifyRoute';

  static const _i17.PageInfo<void> page = _i17.PageInfo<void>(name);
}

/// generated route for
/// [_i10.OverViewScreen]
class OverViewRoute extends _i17.PageRouteInfo<void> {
  const OverViewRoute({List<_i17.PageRouteInfo>? children})
      : super(
          OverViewRoute.name,
          initialChildren: children,
        );

  static const String name = 'OverViewRoute';

  static const _i17.PageInfo<void> page = _i17.PageInfo<void>(name);
}

/// generated route for
/// [_i11.ProfileScreen]
class ProfileRoute extends _i17.PageRouteInfo<void> {
  const ProfileRoute({List<_i17.PageRouteInfo>? children})
      : super(
          ProfileRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProfileRoute';

  static const _i17.PageInfo<void> page = _i17.PageInfo<void>(name);
}

/// generated route for
/// [_i12.QrScannerScreen]
class QrScannerRoute extends _i17.PageRouteInfo<void> {
  const QrScannerRoute({List<_i17.PageRouteInfo>? children})
      : super(
          QrScannerRoute.name,
          initialChildren: children,
        );

  static const String name = 'QrScannerRoute';

  static const _i17.PageInfo<void> page = _i17.PageInfo<void>(name);
}

/// generated route for
/// [_i13.RegisterScreen]
class RegisterRoute extends _i17.PageRouteInfo<void> {
  const RegisterRoute({List<_i17.PageRouteInfo>? children})
      : super(
          RegisterRoute.name,
          initialChildren: children,
        );

  static const String name = 'RegisterRoute';

  static const _i17.PageInfo<void> page = _i17.PageInfo<void>(name);
}

/// generated route for
/// [_i14.SplashScreen]
class SplashRoute extends _i17.PageRouteInfo<void> {
  const SplashRoute({List<_i17.PageRouteInfo>? children})
      : super(
          SplashRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static const _i17.PageInfo<void> page = _i17.PageInfo<void>(name);
}

/// generated route for
/// [_i15.ThemeSettingScreen]
class ThemeSettingRoute extends _i17.PageRouteInfo<void> {
  const ThemeSettingRoute({List<_i17.PageRouteInfo>? children})
      : super(
          ThemeSettingRoute.name,
          initialChildren: children,
        );

  static const String name = 'ThemeSettingRoute';

  static const _i17.PageInfo<void> page = _i17.PageInfo<void>(name);
}

/// generated route for
/// [_i16.UpdateProfileScreen]
class UpdateProfileRoute extends _i17.PageRouteInfo<UpdateProfileRouteArgs> {
  UpdateProfileRoute({
    _i18.Key? key,
    required _i20.UserModel user,
    List<_i17.PageRouteInfo>? children,
  }) : super(
          UpdateProfileRoute.name,
          args: UpdateProfileRouteArgs(
            key: key,
            user: user,
          ),
          initialChildren: children,
        );

  static const String name = 'UpdateProfileRoute';

  static const _i17.PageInfo<UpdateProfileRouteArgs> page =
      _i17.PageInfo<UpdateProfileRouteArgs>(name);
}

class UpdateProfileRouteArgs {
  const UpdateProfileRouteArgs({
    this.key,
    required this.user,
  });

  final _i18.Key? key;

  final _i20.UserModel user;

  @override
  String toString() {
    return 'UpdateProfileRouteArgs{key: $key, user: $user}';
  }
}
