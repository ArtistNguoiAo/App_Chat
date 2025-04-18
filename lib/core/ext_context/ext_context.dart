import 'package:app_chat/core/language/data/base_language.dart';
import 'package:app_chat/core/language/data/en_language.dart';
import 'package:app_chat/core/language/inherited_language_widget.dart';
import 'package:app_chat/core/theme/data/base_theme.dart';
import 'package:app_chat/core/theme/data/light_theme.dart';
import 'package:app_chat/core/theme/inherited_theme_widget.dart';
import 'package:flutter/material.dart';

extension ExtContext on BuildContext {

  BaseTheme get theme {
    return InheritedThemeWidget.of(this)?.getThemeData() ?? LightTheme();
  }

  BaseLanguage get language {
    return InheritedLanguageWidget.of(this)?.getLanguageData() ?? EnLanguage();
  }
}
