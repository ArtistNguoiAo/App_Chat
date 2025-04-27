import 'package:app_chat/core/ext_context/ext_context.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../core/utils/media_utils.dart';
import '../../core/utils/text_style_utils.dart';
import '../../core/widget/base_text_field.dart';
import 'cubit/register_cubit.dart';

@RoutePage()
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isObscure = true;
  bool _isObscureConfirm = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => RegisterCubit(),
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
              _registerWidget()
            ],
          ),
        ));
  }

  Widget _registerWidget() {
    return Builder(builder: (context) {
      return SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.2),
            Container(
              decoration: BoxDecoration(
                color: context.theme.backgroundColor,
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 16),
                    Text(
                      context.language.register,
                      style: TextStyleUtils.bold(
                        fontSize: 32,
                        color: context.theme.textColor,
                        context: context,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _emailController,
                      icon: FontAwesomeIcons.envelope,
                      labelText: 'Email',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email ${context.language.cannotBeEmpty}';
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                          return '${context.language.pleaseEnterValid} email';
                        }
                        return null;
                      },
                    ),
                    _buildTextField(
                      controller: _firstNameController,
                      icon: FontAwesomeIcons.user,
                      labelText: context.language.firstName,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '${context.language.firstName} ${context.language.cannotBeEmpty}';
                        }
                        return null;
                      },
                    ),
                    _buildTextField(
                      controller: _lastNameController,
                      icon: FontAwesomeIcons.user,
                      labelText: context.language.lastName,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '${context.language.lastName} ${context.language.cannotBeEmpty}';
                        }
                        return null;
                      },
                    ),
                    _buildTextField(
                      controller: _usernameController,
                      icon: FontAwesomeIcons.userLarge,
                      labelText: context.language.username,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '${context.language.username} ${context.language.cannotBeEmpty}';
                        }
                        return null;
                      },
                    ),
                    _buildPasswordField(
                      controller: _passwordController,
                      labelText: context.language.password,
                      isObscure: _isObscure,
                      onToggle: () => setState(() => _isObscure = !_isObscure),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '${context.language.password} ${context.language.cannotBeEmpty}';
                        }
                        if (value.length < 6) {
                          return '${context.language.password} ${context.language.mustBeAtLeast} 6 ${context.language.characters}';
                        }
                        return null;
                      },
                    ),
                    _buildPasswordField(
                      controller: _confirmPasswordController,
                      labelText: context.language.confirmPassword,
                      isObscure: _isObscureConfirm,
                      onToggle: () => setState(() => _isObscureConfirm = !_isObscureConfirm),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '${context.language.confirmPassword} ${context.language.cannotBeEmpty}';
                        }
                        if (value != _passwordController.text) {
                          return context.language.passwordsDoNotMatch;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    _buildRegisterButton(),
                    const SizedBox(height: 16),
                    _buildLoginLink(),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required IconData icon,
    required String labelText,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: BaseTextField(
        controller: controller,
        labelText: labelText,
        hintText: labelText,
        validator: validator,
        prefixIcon: Icon(
          icon,
          size: 16,
          color: context.theme.textColor,
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String labelText,
    required bool isObscure,
    required VoidCallback onToggle,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: BaseTextField(
        controller: controller,
        labelText: labelText,
        hintText: labelText,
        validator: validator,
        prefixIcon: Icon(
          FontAwesomeIcons.key,
          size: 16,
          color: context.theme.textColor,
        ),
        suffixIcon: InkWell(
          onTap: onToggle,
          child: Icon(
            isObscure ? FontAwesomeIcons.eyeSlash : FontAwesomeIcons.eye,
            size: 16,
            color: context.theme.textColor,
          ),
        ),
        obscureText: isObscure,
      ),
    );
  }

  Widget _buildRegisterButton() {
    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state is RegisterSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.language.registrationSuccessful),
              backgroundColor: Colors.green,
            ),
          );
          context.router.pop();
        } else if (state is RegisterFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ElevatedButton(
            onPressed: state is RegisterLoading
                ? null
                : () {
                    if (_formKey.currentState?.validate() ?? false) {
                      context.read<RegisterCubit>().register(
                            email: _emailController.text,
                            password: _passwordController.text,
                            username: _usernameController.text,
                            firstName: _firstNameController.text,
                            lastName: _lastNameController.text,
                          );
                    }
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: context.theme.primaryColor,
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: state is RegisterLoading
                ? SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      color: context.theme.backgroundColor,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    context.language.register,
                    style: TextStyleUtils.bold(
                      color: context.theme.backgroundColor,
                      context: context,
                    ),
                  ),
          ),
        );
      },
    );
  }

  Widget _buildLoginLink() {
    return RichText(
      text: TextSpan(
        text: 'Already have an account? ',
        style: TextStyleUtils.normal(
          color: context.theme.textColor,
          context: context,
        ),
        children: [
          TextSpan(
            text: context.language.login,
            style: TextStyleUtils.bold(
              color: context.theme.primaryColor,
              context: context,
            ),
            recognizer: TapGestureRecognizer()..onTap = () => context.router.pop(),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
