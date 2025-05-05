import 'package:app_chat/core/ext_context/ext_context.dart';
import 'package:app_chat/core/utils/text_style_utils.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../core/language/cubit/language_cubit.dart';
import '../../core/language/inherited_language_widget.dart';
import '../../core/router/app_router.gr.dart';
import '../../core/theme/cubit/theme_cubit.dart';
import '../../core/theme/inherited_theme_widget.dart';
import '../../data/model/user_model.dart';
import '../auth/cubit/auth_cubit.dart';

@RoutePage()
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          context.router.replace(const LoginRoute());
        }
      },
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          final user = state.user;
          return Scaffold(
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: Column(
                    children: [
                      _basicInfo(context, user),
                      const SizedBox(height: 16),
                      _changeSetting(
                        icon: FontAwesomeIcons.globe,
                        title: context.language.language,
                        content: InheritedLanguageWidget.of(context)?.languageModeEnum?.displayName ?? "English",
                        onTap: () async {
                          final selectedLanguage = await context.router.push(const LanguageSettingRoute());
                          if (selectedLanguage != null && selectedLanguage is LanguageModeEnum) {
                            context.read<LanguageCubit>().changeLanguage(selectedLanguage);
                          }
                        },
                        context: context,
                      ),
                      const SizedBox(height: 16),
                      _changeSetting(
                        icon: FontAwesomeIcons.sun,
                        title: context.language.theme,
                        content: InheritedThemeWidget.of(context)?.themeModeEnum == ThemeModeEnum.light ? context.language.lightTheme : context.language.darkTheme,
                        onTap: () async {
                          final selectedTheme = await context.router.push(const ThemeSettingRoute());
                          if (selectedTheme != null && selectedTheme is ThemeModeEnum) {
                            context.read<ThemeCubit>().changeTheme(selectedTheme);
                          }
                        },
                        context: context,
                      ),
                      const SizedBox(height: 16),
                      _accountManagement(context),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _basicInfo(BuildContext context, UserModel user) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.theme.backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: context.theme.borderColor,
              image: DecorationImage(
                image: NetworkImage(user.avatar ?? ''),
                fit: BoxFit.cover,
                onError: (error, stackTrace) => const Icon(Icons.person),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: context.theme.textColor,
              borderRadius: BorderRadius.circular(32),
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 4,
              horizontal: 8,
            ),
            child: Text(
              '@${user.username}',
              style: TextStyleUtils.bold(
                fontSize: 16,
                color: context.theme.backgroundColor,
                context: context,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            user.fullName,
            style: TextStyleUtils.bold(
              fontSize: 24,
              color: context.theme.textColor,
              context: context,
            ),
          ),
          // const SizedBox(height: 8),
          // Row(
          //   mainAxisSize: MainAxisSize.min,
          //   children: [
          //     Icon(
          //       FontAwesomeIcons.calendarDay,
          //       color: context.theme.borderColor,
          //       size: 16,
          //     ),
          //     const SizedBox(width: 8),
          //     Text(
          //       'Joined on ${user.createdAt}',
          //       style: TextStyleUtils.normal(
          //         color: context.theme.borderColor,
          //         fontSize: 16,
          //         context: context,
          //       ),
          //     )
          //   ],
          // ),
          const SizedBox(height: 16),
          Container(
            height: 1,
            width: double.infinity,
            color: context.theme.borderColor,
          ),
          const SizedBox(height: 16),
          _name(firstName: user.firstName, lastName: user.lastName, context: context),
        ],
      ),
    );
  }

  Widget _name({
    required String firstName,
    required String lastName,
    required BuildContext context,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              Text(
                context.language.firstName,
                style: TextStyleUtils.normal(
                  color: context.theme.borderColor,
                  fontSize: 16,
                  context: context,
                ),
              ),
              Text(
                firstName,
                style: TextStyleUtils.normal(
                  color: context.theme.textColor,
                  fontSize: 20,
                  context: context,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 1,
          height: 60,
          color: context.theme.borderColor,
        ),
        Expanded(
          child: Column(
            children: [
              Text(
                context.language.lastName,
                style: TextStyleUtils.normal(
                  color: context.theme.borderColor,
                  fontSize: 16,
                  context: context,
                ),
              ),
              Text(
                lastName,
                style: TextStyleUtils.normal(
                  color: context.theme.textColor,
                  fontSize: 20,
                  context: context,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _accountManagement(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.theme.backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            context.language.accountManagement,
            style: TextStyleUtils.bold(
              fontSize: 24,
              color: context.theme.textColor,
              context: context,
            ),
          ),
          // const SizedBox(height: 16),
          // _accountItem(
          //   icon: FontAwesomeIcons.crown,
          //   title: context.language.premiumAccount,
          //   color: context.theme.yellowColor,
          //   onTap: () {},
          //   context: context,
          // ),
          // const SizedBox(height: 16),
          // _accountItem(
          //   icon: FontAwesomeIcons.lock,
          //   title: context.language.changeLanguage,
          //   onTap: () {},
          //   context: context,
          // ),
          const SizedBox(height: 16),
          _accountItem(
            icon: FontAwesomeIcons.userPen,
            title: context.language.updateProfile,
            onTap: () => context.router.push(const UpdateProfileRoute()),
            context: context,
          ),
          const SizedBox(height: 16),
          _accountItem(
            icon: FontAwesomeIcons.lock,
            title: context.language.changePassword,
            onTap: () => context.router.push(const ChangePasswordRoute()),
            context: context,
          ),
          const SizedBox(height: 16),
          _accountItem(
            icon: FontAwesomeIcons.arrowRightFromBracket,
            title: context.language.logout,
            onTap: () => context.read<AuthCubit>().signOut(),
            context: context,
          ),
          // const SizedBox(height: 16),
          // _accountItem(
          //   icon: FontAwesomeIcons.trashCan,
          //   title: context.language.deleteAccount,
          //   color: context.theme.redColor,
          //   onTap: () {},
          //   context: context,
          // ),
        ],
      ),
    );
  }

  Widget _changeSetting({
    required IconData icon,
    required String title,
    required String content,
    VoidCallback? onTap,
    required BuildContext context,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.theme.backgroundColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: context.theme.textColor,
              size: 16,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyleUtils.normal(
                  color: context.theme.textColor,
                  fontSize: 18,
                  context: context,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Text(
              content,
              style: TextStyleUtils.bold(
                color: context.theme.textColor,
                fontSize: 14,
                context: context,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _accountItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? color,
    required BuildContext context,
  }) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            icon,
            color: color ?? context.theme.textColor,
            size: 16,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: TextStyleUtils.normal(
                color: color ?? context.theme.textColor,
                fontSize: 18,
                context: context,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Icon(
            FontAwesomeIcons.chevronRight,
            color: color ?? context.theme.textColor,
            size: 16,
          ),
        ],
      ),
    );
  }
}
