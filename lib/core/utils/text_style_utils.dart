import 'package:flutter/material.dart';

import 'color_utils.dart';
import 'font_utils.dart';

class TextStyleUtils {
  TextStyleUtils._();

  static TextStyle normal({
    double fontSize = 16,
    Color? color,
    TextDecoration decoration = TextDecoration.none,
  }) {
    return TextStyle(
      fontSize: fontSize,
      color: color ?? ColorUtils.textColor,
      fontWeight: FontWeight.w400,
      decoration: decoration,
      fontFamily: FontUtils.nunito,
    );
  }

  static TextStyle normalItalic({
    double fontSize = 16,
    Color? color,
    TextDecoration decoration = TextDecoration.none,
  }) {
    return TextStyle(
      fontSize: fontSize,
      color: color ?? ColorUtils.textColor,
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
  }) {
    return TextStyle(
      fontSize: fontSize,
      color: color ?? ColorUtils.textColor,
      fontWeight: FontWeight.w700,
      decoration: decoration,
      fontFamily: FontUtils.nunito,
    );
  }
}