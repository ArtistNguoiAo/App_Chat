import 'package:app_chat/core/ext_context/ext_context.dart';
import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../core/utils/dialog_utils.dart';
import '../../core/utils/text_style_utils.dart';
import '../../core/widget/base_text_field.dart';
import 'cubit/change_password_cubit.dart';

@RoutePage()
class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChangePasswordCubit(context),
      child: BlocConsumer<ChangePasswordCubit, ChangePasswordState>(
        listener: (context, state) {
          if (state is ChangePasswordLoading) {
            DialogUtils.showLoadingDialog(context);
          }
          if (state is ChangePasswordSuccess) {
            DialogUtils.hideLoadingDialog(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(context.language.updatePasswordSuccessContent),
                backgroundColor: context.theme.greenColor,
              ),
            );
            Navigator.pop(context);
          }
          if (state is ChangePasswordError) {
            DialogUtils.hideLoadingDialog(context);
            DialogUtils.showErrorDialog(
              context: context,
              message: state.message,
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                context.language.changePassword,
                style: TextStyleUtils.bold(
                  fontSize: 20,
                  color: context.theme.backgroundColor,
                  context: context,
                ),
              ),
              leading: InkWell(
                onTap: () {
                  AutoRouter.of(context).maybePop();
                },
                child: Icon(
                  FontAwesomeIcons.chevronLeft,
                  color: context.theme.backgroundColor,
                  size: 18,
                ),
              ),
              centerTitle: true,
              backgroundColor: context.theme.primaryColor,
              elevation: 0,
              actions: [
                IconButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      DialogUtils.showConfirmDialog(
                        context: context,
                        content: context.language.updatePasswordContent,
                        confirmButton: context.language.change,
                        onConfirm: () {
                          context.read<ChangePasswordCubit>().changePassword(
                                currentPassword: _currentPasswordController.text,
                                newPassword: _newPasswordController.text,
                                confirmPassword: _confirmPasswordController.text,
                              );
                        },
                      );
                    }
                  },
                  icon: Icon(
                    FontAwesomeIcons.floppyDisk,
                    size: 18,
                    color: context.theme.backgroundColor,
                  ),
                ),
              ],
            ),
            body: Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: context.theme.backgroundColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      BaseTextField(
                        controller: _currentPasswordController,
                        labelText: context.language.currentPassword,
                        obscureText: _obscureCurrentPassword,
                        prefixIcon: Icon(
                          FontAwesomeIcons.lock,
                          color: context.theme.textColor,
                          size: 16,
                        ),
                        suffixIcon: InkWell(
                          onTap: () => setState(() => _obscureCurrentPassword = !_obscureCurrentPassword),
                          child: Icon(
                            _obscureCurrentPassword ? FontAwesomeIcons.eyeSlash : FontAwesomeIcons.eye,
                            size: 16,
                            color: context.theme.textColor,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return context.language.currentPasswordRequired;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      BaseTextField(
                        controller: _newPasswordController,
                        labelText: context.language.newPassword,
                        obscureText: _obscureNewPassword,
                        prefixIcon: Icon(
                          FontAwesomeIcons.lock,
                          color: context.theme.textColor,
                          size: 16,
                        ),
                        suffixIcon: InkWell(
                          onTap: () => setState(() => _obscureNewPassword = !_obscureNewPassword),
                          child: Icon(
                            _obscureNewPassword ? FontAwesomeIcons.eyeSlash : FontAwesomeIcons.eye,
                            size: 16,
                            color: context.theme.textColor,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return context.language.newPasswordRequired;
                          }
                          if (value.length < 6) {
                            return context.language.passwordTooShort;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      BaseTextField(
                        controller: _confirmPasswordController,
                        labelText: context.language.confirmPassword,
                        obscureText: _obscureConfirmPassword,
                        prefixIcon: Icon(
                          FontAwesomeIcons.lock,
                          color: context.theme.textColor,
                          size: 16,
                        ),
                        suffixIcon: InkWell(
                          onTap: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                          child: Icon(
                            _obscureConfirmPassword ? FontAwesomeIcons.eyeSlash : FontAwesomeIcons.eye,
                            size: 16,
                            color: context.theme.textColor,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return context.language.confirmPasswordRequired;
                          }
                          if (value != _newPasswordController.text) {
                            return context.language.passwordsDoNotMatch;
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
