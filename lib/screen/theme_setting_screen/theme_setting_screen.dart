import 'package:app_chat/core/ext_context/ext_context.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../core/theme/inherited_theme_widget.dart';

@RoutePage()
class ThemeSettingScreen extends StatelessWidget {
  const ThemeSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.language.theme),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text(context.language.lightTheme),
            onTap: () {
              Navigator.pop(context, ThemeModeEnum.light);
            },
          ),
          ListTile(
            title: Text(context.language.darkTheme),
            onTap: () {
              Navigator.pop(context, ThemeModeEnum.dark);
            },
          ),
        ],
      ),
    );
  }
}
