import 'package:app_chat/core/utils/color_utils.dart';
import 'package:app_chat/core/utils/media_utils.dart';
import 'package:app_chat/core/utils/text_style_utils.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/widget/base_text_field.dart';

@RoutePage()
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: SvgPicture.asset(
              MediaUtils.imgBackground,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: MediaQuery.of(context).padding,
            child: Row(
              children: [
                const SizedBox(width: 16),
                Text(
                  'ChitChat',
                  style: TextStyleUtils.bold(
                    fontSize: 48,
                    color: ColorUtils.backgroundColor,
                  ),
                ),
              ],
            ),
          ),
          _loginWidget()
        ],
      ),
    );
  }

  Widget _loginWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          decoration: BoxDecoration(
            color: ColorUtils.backgroundColor,
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              Text(
                'Login',
                style: TextStyleUtils.bold(
                  fontSize: 24,
                  color: ColorUtils.textColor,
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: BaseTextField(
                  controller: TextEditingController(),
                  hintText: 'Username',
                  prefixIcon: const Icon(Icons.email),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: BaseTextField(
                  controller: TextEditingController(),
                  hintText: 'Password',
                  prefixIcon: const Icon(Icons.lock),
                  obscureText: true,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: Container()),
                  Expanded(
                    child: InkWell(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                              color: ColorUtils.primaryColor,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              )),
                          child: Center(
                            child: Text(
                              'Login',
                              style: TextStyleUtils.bold(
                                color: ColorUtils.backgroundColor,
                              ),
                            ),
                          ),
                        )),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
