import 'dart:ui';

import 'package:app_chat/core/theme/data/base_theme.dart';
import 'package:flutter/material.dart';

class LightTheme extends BaseTheme {
  LightTheme._();

  static final LightTheme _instance = LightTheme._();

  factory LightTheme() => _instance;

  @override
  Color get primaryColor => const Color(0xFF00CA87);

  @override
  Color get textColor => const Color(0xFF000000);

  @override
  Color get backgroundColor => const Color(0xFFFFFFFF);

  @override
  Color get borderColor => const Color(0xFF9E9E9E);

  @override
  Color get redColor => Colors.red;

  @override
  Color get yellowColor => Colors.yellow;

  @override
  Color get yellowGold => const Color(0xFFFFDF00);

  @override
  Color get grey300Color => Colors.grey[300]!;
}