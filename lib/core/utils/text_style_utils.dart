import 'package:app_chat/core/ext_context/ext_context.dart';
import 'package:flutter/material.dart';

import 'font_utils.dart';

class TextStyleUtils {
  TextStyleUtils._();

  static TextStyle normal({
    double fontSize = 16,
    Color? color,
    TextDecoration decoration = TextDecoration.none,
    required BuildContext context,
  }) {
    return TextStyle(
      fontSize: fontSize,
      color: color ?? context.theme.textColor,
      fontWeight: FontWeight.w400,
      decoration: decoration,
      fontFamily: FontUtils.nunito,
    );
  }

  static TextStyle normalItalic({
    double fontSize = 16,
    Color? color,
    TextDecoration decoration = TextDecoration.none,
    required BuildContext context,
  }) {
    return TextStyle(
      fontSize: fontSize,
      color: color ?? context.theme.textColor,
      fontWeight: FontWeight.w400,
      decoration: decoration,
      fontFamily: FontUtils.nunito,
      fontStyle: FontStyle.italic,
    );
  }

  static TextStyle bold({
    double fontSize = 16,
    Color? color,
    TextDecoration decoration = TextDecoration.none,
    required BuildContext context,
  }) {
    return TextStyle(
      fontSize: fontSize,
      color: color ?? context.theme.textColor,
      fontWeight: FontWeight.w700,
      decoration: decoration,
      fontFamily: FontUtils.nunito,
    );
  }
}