import 'package:app_chat/core/ext_context/ext_context.dart';
import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';

import '../../core/language/inherited_language_widget.dart';

@RoutePage()
class LanguageSettingScreen extends StatelessWidget {
  const LanguageSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.language.language),
      ),
      body: ListView(
        children: LanguageModeEnum.values.map((language) {
          return ListTile(
            title: Text(language.displayName),
            onTap: () {
              Navigator.pop(context, language);
            },
          );
        }).toList(),
      ),
    );
  }
}
