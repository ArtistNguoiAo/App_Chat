import 'package:app_chat/core/ext_context/ext_context.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class BaseLoading extends StatelessWidget {
  const BaseLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Center(
        child: LoadingAnimationWidget.staggeredDotsWave(
          color: context.theme.primaryColor,
          size: 40,
        ),
      ),
    );
  }
}
