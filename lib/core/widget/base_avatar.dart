import 'package:app_chat/core/ext_context/ext_context.dart';
import 'package:avatar_plus/avatar_plus.dart';
import 'package:flutter/material.dart';

class BaseAvatar extends StatelessWidget {
  const BaseAvatar({
    super.key,
    required this.url,
    required this.randomText,
    required this.size,
  });

  final String url;
  final String randomText;
  final double size;

  @override
  Widget build(BuildContext context) {
    if (url.isNotEmpty) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: context.theme.borderColor,
        ),
        child: ClipOval(
          child: Image.network(
            url,
            fit: BoxFit.cover,
          ),
        ),
      );
    }
    else {
      return AvatarPlus(
        randomText,
        height: size,
        width: size,
      );
    }
  }
}
