import 'package:app_chat/core/theme/data/base_theme.dart';
import 'package:app_chat/core/theme/data/dark_theme.dart';
import 'package:app_chat/core/theme/data/light_theme.dart';
import 'package:flutter/material.dart';

enum ThemeModeEnum { dark, light }

class InheritedThemeWidget extends InheritedWidget {
  final ThemeModeEnum? themeModeEnum;

  const InheritedThemeWidget({
    required super.child,
    this.themeModeEnum,
    super.key,
  });

  @override
  bool updateShouldNotify(InheritedThemeWidget oldWidget) {
    return themeModeEnum != oldWidget.themeModeEnum;
  }

  static InheritedThemeWidget? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InheritedThemeWidget>();
  }

  BaseTheme getThemeData() {
    switch (themeModeEnum) {
      case ThemeModeEnum.dark:
        return DarkTheme();
      case ThemeModeEnum.light:
        return LightTheme();
      default:
        return LightTheme();
    }
  }
}