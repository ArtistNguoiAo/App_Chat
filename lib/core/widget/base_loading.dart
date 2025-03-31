import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../utils/color_utils.dart';

class BaseLoading extends StatelessWidget {
  const BaseLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Center(
        child: LoadingAnimationWidget.staggeredDotsWave(
          color: ColorUtils.primaryColor,
          size: 40,
        ),
      ),
    );
  }
}
