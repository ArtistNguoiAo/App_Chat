import 'package:app_chat/core/ext_context/ext_context.dart';
import 'package:app_chat/core/router/app_router.gr.dart';
import 'package:app_chat/core/utils/media_utils.dart';
import 'package:app_chat/core/utils/text_style_utils.dart';
import 'package:app_chat/screen/login_screen/cubit/login_cubit.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../core/widget/base_text_field.dart';
import '../../data/local_cache.dart';

@RoutePage()
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isObscure = true;
  bool _rememberMe = false;
  late final LoginCubit _loginCubit;

  @override
  void initState() {
    super.initState();
    _loginCubit = LoginCubit();
  }

  @override
  void dispose() {
    _loginCubit.close();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _loginCubit,
      child: BlocListener<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            AutoRouter.of(context).replace(const OverViewRoute());
          } else if (state is LoginFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        },
        child: Scaffold(
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
                      context.language.appName,
                      style: TextStyleUtils.bold(
                        fontSize: 48,
                        color: context.theme.backgroundColor,
                        context: context,
                      ),
                    ),
                  ],
                ),
              ),
              _loginWidget()
            ],
          ),
        ),
      ),
    );
  }

  Widget _loginWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          decoration: BoxDecoration(
            color: context.theme.backgroundColor,
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              Text(
                context.language.login,
                style: TextStyleUtils.bold(
                  fontSize: 32,
                  color: context.theme.textColor,
                  context: context,
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: BaseTextField(
                  controller: _emailController,
                  labelText: context.language.email,
                  hintText: context.language.email,
                  prefixIcon: Icon(
                    FontAwesomeIcons.envelope,
                    size: 16,
                    color: context.theme.textColor,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: BaseTextField(
                  controller: _passwordController,
                  labelText: context.language.password,
                  hintText: context.language.password,
                  prefixIcon: Icon(
                    FontAwesomeIcons.key,
                    size: 16,
                    color: context.theme.textColor,
                  ),
                  suffixIcon: InkWell(
                    onTap: () => setState(() => _isObscure = !_isObscure),
                    child: Icon(
                      _isObscure ? FontAwesomeIcons.eyeSlash : FontAwesomeIcons.eye,
                      size: 16,
                      color: context.theme.textColor,
                    ),
                  ),
                  obscureText: _isObscure,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Checkbox(
                    value: _rememberMe,
                    checkColor: context.theme.backgroundColor,
                    activeColor: context.theme.primaryColor,
                    onChanged: (value) => setState(() => _rememberMe = value ?? false),
                  ),
                  Text(
                    context.language.rememberMe,
                    style: TextStyleUtils.normal(
                      color: context.theme.textColor,
                      context: context,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              BlocBuilder<LoginCubit, LoginState>(
                builder: (context, state) {
                  return Row(
                    children: [
                      Expanded(child: Container()),
                      Expanded(
                        child: InkWell(
                          onTap: state is LoginLoading
                              ? null
                              : () {
                                  context.read<LoginCubit>().login(
                                        email: _emailController.text,
                                        password: _passwordController.text,
                                      );
                                },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: context.theme.primaryColor,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              ),
                            ),
                            child: Center(
                              child: state is LoginLoading
                                  ? const CircularProgressIndicator(color: Colors.white)
                                  : Text(
                                      context.language.login,
                                      style: TextStyleUtils.bold(
                                        color: context.theme.backgroundColor,
                                        context: context,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              )
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text.rich(
          TextSpan(
            text: context.language.notHaveAnAccount,
            children: [
              TextSpan(
                text: ' ${context.language.register}',
                style: TextStyleUtils.normal(
                  fontSize: 14,
                  color: context.theme.primaryColor,
                  context: context,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    AutoRouter.of(context).push(const RegisterRoute());
                  },
              ),
            ],
          ),
          style: TextStyleUtils.normal(
            fontSize: 14,
            color: context.theme.textColor,
            context: context,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
