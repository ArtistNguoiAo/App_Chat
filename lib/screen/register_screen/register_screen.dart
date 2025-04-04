import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../core/utils/color_utils.dart';
import '../../core/utils/media_utils.dart';
import '../../core/utils/text_style_utils.dart';
import '../../core/widget/base_text_field.dart';

@RoutePage()
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isObscure = true;
  bool _isObscureConfirm = true;

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
                'Register',
                style: TextStyleUtils.bold(
                  fontSize: 32,
                  color: ColorUtils.textColor,
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: BaseTextField(
                  controller: _usernameController,
                  labelText: 'Username',
                  hintText: 'Username',
                  prefixIcon: Icon(
                    FontAwesomeIcons.userLarge,
                    size: 16,
                    color: ColorUtils.textColor,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: BaseTextField(
                  controller: _passwordController,
                  labelText: 'Password',
                  hintText: 'Password',
                  prefixIcon: Icon(
                    FontAwesomeIcons.key,
                    size: 16,
                    color: ColorUtils.textColor,
                  ),
                  suffixIcon: InkWell(
                    onTap: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    },
                    child: Icon(
                      _isObscure ? FontAwesomeIcons.eyeSlash : FontAwesomeIcons.eye,
                      size: 16,
                      color: ColorUtils.textColor,
                    ),
                  ),
                  obscureText: _isObscure,
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: BaseTextField(
                  controller: _confirmPasswordController,
                  labelText: 'Confirm Password',
                  hintText: 'Confirm Password',
                  prefixIcon: Icon(
                    FontAwesomeIcons.key,
                    size: 16,
                    color: ColorUtils.textColor,
                  ),
                  suffixIcon: InkWell(
                    onTap: () {
                      setState(() {
                        _isObscureConfirm = !_isObscureConfirm;
                      });
                    },
                    child: Icon(
                      _isObscureConfirm ? FontAwesomeIcons.eyeSlash : FontAwesomeIcons.eye,
                      size: 16,
                      color: ColorUtils.textColor,
                    ),
                  ),
                  obscureText: _isObscureConfirm,
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
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: ColorUtils.primaryColor,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              )),
                          child: Center(
                            child: Text(
                              'Register',
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
