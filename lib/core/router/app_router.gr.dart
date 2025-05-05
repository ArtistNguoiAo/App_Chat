// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:app_chat/data/model/user_model.dart' as _i15;
import 'package:app_chat/screen/home_screen/home_screen.dart' as _i3;
import 'package:app_chat/screen/list_message_screen/list_message_screen.dart'
    as _i5;
import 'package:app_chat/screen/login_screen/forgot_password_screen.dart'
    as _i2;
import 'package:app_chat/screen/login_screen/login_screen.dart' as _i6;
import 'package:app_chat/screen/message_screen/message_screen.dart' as _i7;
import 'package:app_chat/screen/over_view_screen/over_view_screen.dart' as _i8;
import 'package:app_chat/screen/profile_screen/change_password_screen.dart'
    as _i1;
import 'package:app_chat/screen/profile_screen/language_setting_screen.dart'
    as _i4;
import 'package:app_chat/screen/profile_screen/profile_screen.dart' as _i9;
import 'package:app_chat/screen/profile_screen/theme_setting_screen.dart'
    as _i11;
import 'package:app_chat/screen/profile_screen/update_profile_screen.dart'
    as _i12;
import 'package:app_chat/screen/register_screen/register_screen.dart' as _i10;
import 'package:auto_route/auto_route.dart' as _i13;
import 'package:flutter/material.dart' as _i14;

abstract class $AppRouter extends _i13.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i13.PageFactory> pagesMap = {
    ChangePasswordRoute.name: (routeData) {
      return _i13.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i1.ChangePasswordScreen(),
      );
    },
    ForgotPasswordRoute.name: (routeData) {
      return _i13.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i2.ForgotPasswordScreen(),
      );
    },
    HomeRoute.name: (routeData) {
      return _i13.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i3.HomeScreen(),
      );
    },
    LanguageSettingRoute.name: (routeData) {
      return _i13.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i4.LanguageSettingScreen(),
      );
    },
    ListMessageRoute.name: (routeData) {
      final args = routeData.argsAs<ListMessageRouteArgs>(
          orElse: () => const ListMessageRouteArgs());
      return _i13.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i5.ListMessageScreen(key: args.key),
      );
    },
    LoginRoute.name: (routeData) {
      return _i13.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i6.LoginScreen(),
      );
    },
    MessageRoute.name: (routeData) {
      final args = routeData.argsAs<MessageRouteArgs>();
      return _i13.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i7.MessageScreen(
          key: args.key,
          listOtherUser: args.listSeenBy,
          currentUser: args.currentUser,
        ),
      );
    },
    OverViewRoute.name: (routeData) {
      return _i13.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i8.OverViewScreen(),
      );
    },
    ProfileRoute.name: (routeData) {
      return _i13.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i9.ProfileScreen(),
      );
    },
    RegisterRoute.name: (routeData) {
      return _i13.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i10.RegisterScreen(),
      );
    },
    ThemeSettingRoute.name: (routeData) {
      return _i13.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i11.ThemeSettingScreen(),
      );
    },
    UpdateProfileRoute.name: (routeData) {
      return _i13.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i12.UpdateProfileScreen(),
      );
    },
  };
}

/// generated route for
/// [_i1.ChangePasswordScreen]
class ChangePasswordRoute extends _i13.PageRouteInfo<void> {
  const ChangePasswordRoute({List<_i13.PageRouteInfo>? children})
      : super(
          ChangePasswordRoute.name,
          initialChildren: children,
        );

  static const String name = 'ChangePasswordRoute';

  static const _i13.PageInfo<void> page = _i13.PageInfo<void>(name);
}

/// generated route for
/// [_i2.ForgotPasswordScreen]
class ForgotPasswordRoute extends _i13.PageRouteInfo<void> {
  const ForgotPasswordRoute({List<_i13.PageRouteInfo>? children})
      : super(
          ForgotPasswordRoute.name,
          initialChildren: children,
        );

  static const String name = 'ForgotPasswordRoute';

  static const _i13.PageInfo<void> page = _i13.PageInfo<void>(name);
}

/// generated route for
/// [_i3.HomeScreen]
class HomeRoute extends _i13.PageRouteInfo<void> {
  const HomeRoute({List<_i13.PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static const _i13.PageInfo<void> page = _i13.PageInfo<void>(name);
}

/// generated route for
/// [_i4.LanguageSettingScreen]
class LanguageSettingRoute extends _i13.PageRouteInfo<void> {
  const LanguageSettingRoute({List<_i13.PageRouteInfo>? children})
      : super(
          LanguageSettingRoute.name,
          initialChildren: children,
        );

  static const String name = 'LanguageSettingRoute';

  static const _i13.PageInfo<void> page = _i13.PageInfo<void>(name);
}

/// generated route for
/// [_i5.ListMessageScreen]
class ListMessageRoute extends _i13.PageRouteInfo<ListMessageRouteArgs> {
  ListMessageRoute({
    _i14.Key? key,
    List<_i13.PageRouteInfo>? children,
  }) : super(
          ListMessageRoute.name,
          args: ListMessageRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'ListMessageRoute';

  static const _i13.PageInfo<ListMessageRouteArgs> page =
      _i13.PageInfo<ListMessageRouteArgs>(name);
}

class ListMessageRouteArgs {
  const ListMessageRouteArgs({this.key});

  final _i14.Key? key;

  @override
  String toString() {
    return 'ListMessageRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i6.LoginScreen]
class LoginRoute extends _i13.PageRouteInfo<void> {
  const LoginRoute({List<_i13.PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static const _i13.PageInfo<void> page = _i13.PageInfo<void>(name);
}

/// generated route for
/// [_i7.MessageScreen]
class MessageRoute extends _i13.PageRouteInfo<MessageRouteArgs> {
  MessageRoute({
    _i14.Key? key,
    required List<_i15.UserModel> listSeenBy,
    required _i15.UserModel currentUser,
    List<_i13.PageRouteInfo>? children,
  }) : super(
          MessageRoute.name,
          args: MessageRouteArgs(
            key: key,
            listSeenBy: listSeenBy,
            currentUser: currentUser,
          ),
          initialChildren: children,
        );

  static const String name = 'MessageRoute';

  static const _i13.PageInfo<MessageRouteArgs> page =
      _i13.PageInfo<MessageRouteArgs>(name);
}

class MessageRouteArgs {
  const MessageRouteArgs({
    this.key,
    required this.listSeenBy,
    required this.currentUser,
  });

  final _i14.Key? key;

  final List<_i15.UserModel> listSeenBy;

  final _i15.UserModel currentUser;

  @override
  String toString() {
    return 'MessageRouteArgs{key: $key, listSeenBy: $listSeenBy, currentUser: $currentUser}';
  }
}

/// generated route for
/// [_i8.OverViewScreen]
class OverViewRoute extends _i13.PageRouteInfo<void> {
  const OverViewRoute({List<_i13.PageRouteInfo>? children})
      : super(
          OverViewRoute.name,
          initialChildren: children,
        );

  static const String name = 'OverViewRoute';

  static const _i13.PageInfo<void> page = _i13.PageInfo<void>(name);
}

/// generated route for
/// [_i9.ProfileScreen]
class ProfileRoute extends _i13.PageRouteInfo<void> {
  const ProfileRoute({List<_i13.PageRouteInfo>? children})
      : super(
          ProfileRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProfileRoute';

  static const _i13.PageInfo<void> page = _i13.PageInfo<void>(name);
}

/// generated route for
/// [_i10.RegisterScreen]
class RegisterRoute extends _i13.PageRouteInfo<void> {
  const RegisterRoute({List<_i13.PageRouteInfo>? children})
      : super(
          RegisterRoute.name,
          initialChildren: children,
        );

  static const String name = 'RegisterRoute';

  static const _i13.PageInfo<void> page = _i13.PageInfo<void>(name);
}

/// generated route for
/// [_i11.ThemeSettingScreen]
class ThemeSettingRoute extends _i13.PageRouteInfo<void> {
  const ThemeSettingRoute({List<_i13.PageRouteInfo>? children})
      : super(
          ThemeSettingRoute.name,
          initialChildren: children,
        );

  static const String name = 'ThemeSettingRoute';

  static const _i13.PageInfo<void> page = _i13.PageInfo<void>(name);
}

/// generated route for
/// [_i12.UpdateProfileScreen]
class UpdateProfileRoute extends _i13.PageRouteInfo<void> {
  const UpdateProfileRoute({List<_i13.PageRouteInfo>? children})
      : super(
          UpdateProfileRoute.name,
          initialChildren: children,
        );

  static const String name = 'UpdateProfileRoute';

  static const _i13.PageInfo<void> page = _i13.PageInfo<void>(name);
}
