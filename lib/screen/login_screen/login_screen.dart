import 'package:app_chat/core/ext_context/ext_context.dart';
import 'package:app_chat/core/router/app_router.gr.dart';
import 'package:app_chat/core/utils/dialog_utils.dart';
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

@RoutePage()
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isObscure = true;
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit()..init(),
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginLoaded) {
            _emailController.text = state.email;
            _passwordController.text = state.password;
            _rememberMe = state.rememberMe;
          }
          if (state is LoginSuccess) {
            DialogUtils.hideLoadingDialog(context);
            AutoRouter.of(context).replace(const OverViewRoute());
          }
          if (state is LoginLoading) {
            DialogUtils.showLoadingDialog(context);
          }
          if (state is LoginError) {
            DialogUtils.hideLoadingDialog(context);
            DialogUtils.showErrorDialog(
              context: context,
              message: state.error,
            );
          }
        },
        builder: (context, state) {
          if (state is LoginLoaded) {
            return Scaffold(
              body: Padding(
                padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                child: Stack(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: SvgPicture.asset(
                        MediaUtils.imgBackground,
                        fit: BoxFit.cover,
                      ),
                    ),
                    _loginWidget(context),
                  ],
                ),
              ),
            );
          }
          return Scaffold(
            body: Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: Stack(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: SvgPicture.asset(
                      MediaUtils.imgBackground,
                      fit: BoxFit.cover,
                    ),
                  ),
                  _loginWidget(context),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _loginWidget(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
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
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return context.language.emailRequired;
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: BaseTextField(
                    controller: _passwordController,
                    labelText: context.language.password,
                    hintText: context.language.password,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return context.language.passwordRequired;
                      }
                      return null;
                    },
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
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => context.router.push(const ForgotPasswordRoute()),
                    child: Text(
                      context.language.forgotPassword,
                      style: TextStyleUtils.normal(
                        color: context.theme.primaryColor,
                        context: context,
                      ),
                    ),
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
                Row(
                  children: [
                    Expanded(child: Container()),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          context.read<LoginCubit>().login(
                            email: _emailController.text,
                            password: _passwordController.text,
                            rememberMe: _rememberMe,
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
                            child: Text(
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
                ),
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
      ),
    );
  }
}
