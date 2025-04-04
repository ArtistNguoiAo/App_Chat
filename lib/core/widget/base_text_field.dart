import 'package:flutter/material.dart';

import '../utils/color_utils.dart';
import '../utils/text_style_utils.dart';

class BaseTextField extends StatefulWidget {
  BaseTextField({
    super.key,
    required this.controller,
    this.border,
    this.focusedBorder,
    this.errorBorder,
    this.enabledBorder,
    this.disabledBorder,
    this.hintText,
    this.labelText,
    this.hintStyle,
    this.labelStyle,
    this.style,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText,
  });

  final TextEditingController controller;
  final InputBorder? border;
  final InputBorder? focusedBorder;
  final InputBorder? errorBorder;
  final InputBorder? enabledBorder;
  final InputBorder? disabledBorder;
  final String? hintText;
  final String? labelText;
  final TextStyle? hintStyle;
  final TextStyle? labelStyle;
  final TextStyle? style;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool? obscureText;

  @override
  State<BaseTextField> createState() => _BaseTextFieldState();
}

class _BaseTextFieldState extends State<BaseTextField> {

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      decoration: InputDecoration(
        border: widget.border ?? OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: ColorUtils.borderColor)),
        focusedBorder: widget.focusedBorder ??
            OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: ColorUtils.primaryColor)),
        errorBorder:
            widget.errorBorder ?? OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: ColorUtils.borderColor)),
        enabledBorder: widget.enabledBorder ??
            OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: ColorUtils.borderColor)),
        disabledBorder: widget.disabledBorder ??
            OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: ColorUtils.borderColor)),
        hintText: widget.hintText,
        hintStyle: widget.labelStyle ?? TextStyleUtils.normal(
          color: ColorUtils.borderColor,
        ),
        labelText: widget.labelText,
        labelStyle: widget.hintStyle ?? TextStyleUtils.normal(
          color: ColorUtils.borderColor,
        ),
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.suffixIcon,
      ),
      style: widget.style ?? TextStyleUtils.normal(),
      obscureText: widget.obscureText ?? false,
    );
  }
}
