// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:app_chat/data/model/user_model.dart' as _i12;
import 'package:app_chat/screen/login_screen/forgot_password_screen.dart'
    as _i2;
import 'package:app_chat/screen/login_screen/login_screen.dart' as _i4;
import 'package:app_chat/screen/message_screen/message_screen.dart' as _i5;
import 'package:app_chat/screen/over_view_screen/over_view_screen.dart' as _i6;
import 'package:app_chat/screen/profile_screen/change_password_screen.dart'
    as _i1;
import 'package:app_chat/screen/profile_screen/language_setting_screen.dart'
    as _i3;
import 'package:app_chat/screen/profile_screen/theme_setting_screen.dart'
    as _i8;
import 'package:app_chat/screen/profile_screen/update_profile_screen.dart'
    as _i9;
import 'package:app_chat/screen/register_screen/register_screen.dart' as _i7;
import 'package:auto_route/auto_route.dart' as _i10;
import 'package:flutter/material.dart' as _i11;

abstract class $AppRouter extends _i10.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i10.PageFactory> pagesMap = {
    ChangePasswordRoute.name: (routeData) {
      return _i10.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i1.ChangePasswordScreen(),
      );
    },
    ForgotPasswordRoute.name: (routeData) {
      return _i10.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i2.ForgotPasswordScreen(),
      );
    },
    LanguageSettingRoute.name: (routeData) {
      return _i10.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i3.LanguageSettingScreen(),
      );
    },
    LoginRoute.name: (routeData) {
      return _i10.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i4.LoginScreen(),
      );
    },
    MessageRoute.name: (routeData) {
      final args = routeData.argsAs<MessageRouteArgs>();
      return _i10.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i5.MessageScreen(
          key: args.key,
          user: args.user,
        ),
      );
    },
    OverViewRoute.name: (routeData) {
      return _i10.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i6.OverViewScreen(),
      );
    },
    RegisterRoute.name: (routeData) {
      return _i10.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i7.RegisterScreen(),
      );
    },
    ThemeSettingRoute.name: (routeData) {
      return _i10.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i8.ThemeSettingScreen(),
      );
    },
    UpdateProfileRoute.name: (routeData) {
      return _i10.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i9.UpdateProfileScreen(),
      );
    },
  };
}

/// generated route for
/// [_i1.ChangePasswordScreen]
class ChangePasswordRoute extends _i10.PageRouteInfo<void> {
  const ChangePasswordRoute({List<_i10.PageRouteInfo>? children})
      : super(
          ChangePasswordRoute.name,
          initialChildren: children,
        );

  static const String name = 'ChangePasswordRoute';

  static const _i10.PageInfo<void> page = _i10.PageInfo<void>(name);
}

/// generated route for
/// [_i2.ForgotPasswordScreen]
class ForgotPasswordRoute extends _i10.PageRouteInfo<void> {
  const ForgotPasswordRoute({List<_i10.PageRouteInfo>? children})
      : super(
          ForgotPasswordRoute.name,
          initialChildren: children,
        );

  static const String name = 'ForgotPasswordRoute';

  static const _i10.PageInfo<void> page = _i10.PageInfo<void>(name);
}

/// generated route for
/// [_i3.LanguageSettingScreen]
class LanguageSettingRoute extends _i10.PageRouteInfo<void> {
  const LanguageSettingRoute({List<_i10.PageRouteInfo>? children})
      : super(
          LanguageSettingRoute.name,
          initialChildren: children,
        );

  static const String name = 'LanguageSettingRoute';

  static const _i10.PageInfo<void> page = _i10.PageInfo<void>(name);
}

/// generated route for
/// [_i4.LoginScreen]
class LoginRoute extends _i10.PageRouteInfo<void> {
  const LoginRoute({List<_i10.PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static const _i10.PageInfo<void> page = _i10.PageInfo<void>(name);
}

/// generated route for
/// [_i5.MessageScreen]
class MessageRoute extends _i10.PageRouteInfo<MessageRouteArgs> {
  MessageRoute({
    _i11.Key? key,
    required _i12.UserModel user,
    List<_i10.PageRouteInfo>? children,
  }) : super(
          MessageRoute.name,
          args: MessageRouteArgs(
            key: key,
            user: user,
          ),
          initialChildren: children,
        );

  static const String name = 'MessageRoute';

  static const _i10.PageInfo<MessageRouteArgs> page =
      _i10.PageInfo<MessageRouteArgs>(name);
}

class MessageRouteArgs {
  const MessageRouteArgs({
    this.key,
    required this.user,
  });

  final _i11.Key? key;

  final _i12.UserModel user;

  @override
  String toString() {
    return 'MessageRouteArgs{key: $key, user: $user}';
  }
}

/// generated route for
/// [_i6.OverViewScreen]
class OverViewRoute extends _i10.PageRouteInfo<void> {
  const OverViewRoute({List<_i10.PageRouteInfo>? children})
      : super(
          OverViewRoute.name,
          initialChildren: children,
        );

  static const String name = 'OverViewRoute';

  static const _i10.PageInfo<void> page = _i10.PageInfo<void>(name);
}

/// generated route for
/// [_i7.RegisterScreen]
class RegisterRoute extends _i10.PageRouteInfo<void> {
  const RegisterRoute({List<_i10.PageRouteInfo>? children})
      : super(
          RegisterRoute.name,
          initialChildren: children,
        );

  static const String name = 'RegisterRoute';

  static const _i10.PageInfo<void> page = _i10.PageInfo<void>(name);
}

/// generated route for
/// [_i8.ThemeSettingScreen]
class ThemeSettingRoute extends _i10.PageRouteInfo<void> {
  const ThemeSettingRoute({List<_i10.PageRouteInfo>? children})
      : super(
          ThemeSettingRoute.name,
          initialChildren: children,
        );

  static const String name = 'ThemeSettingRoute';

  static const _i10.PageInfo<void> page = _i10.PageInfo<void>(name);
}

/// generated route for
/// [_i9.UpdateProfileScreen]
class UpdateProfileRoute extends _i10.PageRouteInfo<void> {
  const UpdateProfileRoute({List<_i10.PageRouteInfo>? children})
      : super(
          UpdateProfileRoute.name,
          initialChildren: children,
        );

  static const String name = 'UpdateProfileRoute';

  static const _i10.PageInfo<void> page = _i10.PageInfo<void>(name);
}
