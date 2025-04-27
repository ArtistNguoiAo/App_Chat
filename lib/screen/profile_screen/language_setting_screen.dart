import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../core/ext_context/ext_context.dart';
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
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: context.theme.backgroundColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...List.generate(
                LanguageModeEnum.values.length,
                (index) {
                  final language = LanguageModeEnum.values[index];
                  final isSelected = InheritedLanguageWidget.of(context)?.languageModeEnum == language;

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                        leading: Icon(
                          FontAwesomeIcons.language,
                          size: 16,
                          color: isSelected ? context.theme.primaryColor : context.theme.textColor,
                        ),
                        title: Text(
                          language.displayName,
                          style: TextStyle(
                            color: isSelected ? context.theme.primaryColor : context.theme.textColor,
                          ),
                        ),
                        trailing: isSelected
                            ? Icon(
                                FontAwesomeIcons.check,
                                size: 16,
                                color: context.theme.primaryColor,
                              )
                            : null,
                        onTap: () => Navigator.pop(context, language),
                      ),
                      if (index < LanguageModeEnum.values.length - 1)
                        Divider(
                          color: context.theme.borderColor,
                          height: 1,
                        ),
                    ],
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
