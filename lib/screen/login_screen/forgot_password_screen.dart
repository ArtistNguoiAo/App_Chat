import 'package:app_chat/core/ext_context/ext_context.dart';
import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../core/utils/text_style_utils.dart';
import '../../core/widget/base_text_field.dart';
import 'cubit/forgot_password_cubit.dart';

@RoutePage()
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  late final ForgotPasswordCubit _forgotPasswordCubit;

  @override
  void initState() {
    super.initState();
    _forgotPasswordCubit = ForgotPasswordCubit(context);
  }

  @override
  void dispose() {
    _forgotPasswordCubit.close();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _forgotPasswordCubit,
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.language.forgotPassword),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                context.language.forgotPasswordDescription,
                style: TextStyleUtils.normal(
                  fontSize: 16,
                  color: context.theme.textColor,
                  context: context,
                ),
              ),
              const SizedBox(height: 16),
              BaseTextField(
                controller: _emailController,
                labelText: context.language.email,
                hintText: context.language.enterEmail,
                prefixIcon: Icon(
                  FontAwesomeIcons.envelope,
                  size: 16,
                  color: context.theme.textColor,
                ),
              ),
              const SizedBox(height: 16),
              BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
                listener: (context, state) {
                  if (state is ForgotPasswordSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(context.language.resetPasswordEmailSent)),
                    );
                    Navigator.pop(context);
                  } else if (state is ForgotPasswordError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.error)),
                    );
                  }
                },
                builder: (context, state) {
                  return ElevatedButton(
                    onPressed: state is ForgotPasswordLoading ? null : () => _forgotPasswordCubit.resetPassword(_emailController.text),
                    child: state is ForgotPasswordLoading ? const CircularProgressIndicator() : Text(context.language.resetPassword),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
