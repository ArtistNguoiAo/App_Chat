import 'package:app_chat/core/ext_context/ext_context.dart';
import 'package:app_chat/core/utils/text_style_utils.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Column(
              children: [
                _basicInfo(context),
                const SizedBox(height: 16),
                _changeSetting(
                  icon: FontAwesomeIcons.globe,
                  title: context.language.language,
                  content: "English",
                  context: context,
                ),
                const SizedBox(height: 16),
                _changeSetting(
                  icon: FontAwesomeIcons.sun,
                  title: context.language.theme,
                  content: "Light",
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

  Widget _basicInfo(BuildContext context) {
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
              image: const DecorationImage(
                image: NetworkImage(
                  '',
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: Icon(Icons.add_a_photo, color: context.theme.backgroundColor),
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
              '@johndoe',
              style: TextStyleUtils.bold(
                fontSize: 16,
                color: context.theme.backgroundColor,
                context: context,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'John Doe',
            style: TextStyleUtils.bold(
              fontSize: 24,
              color: context.theme.textColor,
              context: context,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                FontAwesomeIcons.calendarDay,
                color: context.theme.borderColor,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                'Joined on 01 Jan 2023',
                style: TextStyleUtils.normal(
                  color: context.theme.borderColor,
                  fontSize: 16,
                  context: context,
                ),
              )
            ],
          ),
          const SizedBox(height: 16),
          Container(
            height: 1,
            width: double.infinity,
            color: context.theme.borderColor,
          ),
          const SizedBox(height: 16),
          _name(firstName: "John", lastName: "Doe", context: context),
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
          const SizedBox(height: 16),
          _accountItem(
            icon: FontAwesomeIcons.crown,
            title: context.language.premiumAccount,
            color: context.theme.yellowColor,
            onTap: () {},
            context: context,
          ),
          const SizedBox(height: 16),
          _accountItem(
            icon: FontAwesomeIcons.lock,
            title: context.language.changeLanguage,
            onTap: () {},
            context: context,
          ),
          const SizedBox(height: 16),
          _accountItem(
            icon: FontAwesomeIcons.arrowRightFromBracket,
            title: context.language.logout,
            onTap: () {},
            context: context,
          ),
          const SizedBox(height: 16),
          _accountItem(
            icon: FontAwesomeIcons.trashCan,
            title: context.language.deleteAccount,
            color: context.theme.redColor,
            onTap: () {},
            context: context,
          ),
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
