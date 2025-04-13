import 'package:app_chat/core/utils/color_utils.dart';
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
                _basicInfo(),
                const SizedBox(height: 16),
                _changeSetting(
                  icon: FontAwesomeIcons.globe,
                  title: "Language",
                  content: "English",
                ),
                const SizedBox(height: 16),
                _changeSetting(
                  icon: FontAwesomeIcons.sun,
                  title: "Theme",
                  content: "Light",
                ),
                const SizedBox(height: 16),
                _accountManagement(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _basicInfo() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorUtils.backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ColorUtils.borderColor,
              image: const DecorationImage(
                image: NetworkImage(
                  '',
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: Icon(Icons.add_a_photo, color: ColorUtils.backgroundColor),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: ColorUtils.textColor,
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
                color: ColorUtils.backgroundColor,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'John Doe',
            style: TextStyleUtils.bold(
              fontSize: 24,
              color: ColorUtils.textColor,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                FontAwesomeIcons.calendarDay,
                color: ColorUtils.borderColor,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                'Joined on 01 Jan 2023',
                style: TextStyleUtils.normal(
                  color: ColorUtils.borderColor,
                  fontSize: 16,
                ),
              )
            ],
          ),
          const SizedBox(height: 16),
          Container(
            height: 1,
            width: double.infinity,
            color: ColorUtils.borderColor,
          ),
          const SizedBox(height: 16),
          _name(firstName: "John", lastName: "Doe")
        ],
      ),
    );
  }

  Widget _name({
    required String firstName,
    required String lastName,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              Text(
                "First Name",
                style: TextStyleUtils.normal(
                  color: ColorUtils.borderColor,
                  fontSize: 16,
                ),
              ),
              Text(
                firstName,
                style: TextStyleUtils.normal(
                  color: ColorUtils.textColor,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 1,
          height: 60,
          color: ColorUtils.borderColor,
        ),
        Expanded(
          child: Column(
            children: [
              Text(
                "Last Name",
                style: TextStyleUtils.normal(
                  color: ColorUtils.borderColor,
                  fontSize: 16,
                ),
              ),
              Text(
                lastName,
                style: TextStyleUtils.normal(
                  color: ColorUtils.textColor,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _accountManagement() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorUtils.backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            'Account Management',
            style: TextStyleUtils.bold(
              fontSize: 24,
              color: ColorUtils.textColor,
            ),
          ),
          const SizedBox(height: 16),
          _accountItem(
            icon: FontAwesomeIcons.crown,
            title: 'Premium Account',
            color: ColorUtils.yellowColor,
            onTap: () {},
          ),
          const SizedBox(height: 16),
          _accountItem(
            icon: FontAwesomeIcons.lock,
            title: 'Change Password',
            onTap: () {},
          ),
          const SizedBox(height: 16),
          _accountItem(
            icon: FontAwesomeIcons.arrowRightFromBracket,
            title: 'Logout',
            onTap: () {},
          ),
          const SizedBox(height: 16),
          _accountItem(
            icon: FontAwesomeIcons.trashCan,
            title: 'Delete Account',
            color: ColorUtils.redColor,
            onTap: () {},
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
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: ColorUtils.backgroundColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: ColorUtils.textColor,
              size: 16,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyleUtils.normal(
                  color: ColorUtils.textColor,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Text(
              content,
              style: TextStyleUtils.bold(
                color: ColorUtils.textColor,
                fontSize: 14,
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
  }) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            icon,
            color: color ?? ColorUtils.textColor,
            size: 16,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: TextStyleUtils.normal(
                color: color ?? ColorUtils.textColor,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Icon(
            FontAwesomeIcons.chevronRight,
            color: color ?? ColorUtils.textColor,
            size: 16,
          ),
        ],
      ),
    );
  }
}
