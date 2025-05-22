import 'package:app_chat/core/utils/text_style_utils.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../core/ext_context/ext_context.dart';
import '../../core/theme/inherited_theme_widget.dart';

@RoutePage()
class ThemeSettingScreen extends StatelessWidget {
  const ThemeSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.language.theme,
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
                ThemeModeEnum.values.length,
                (index) {
                  final theme = ThemeModeEnum.values[index];
                  final isSelected = InheritedThemeWidget.of(context)?.themeModeEnum == theme;

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                        leading: Icon(
                          theme == ThemeModeEnum.light ? FontAwesomeIcons.sun : FontAwesomeIcons.moon,
                          size: 16,
                          color: isSelected ? context.theme.primaryColor : context.theme.textColor,
                        ),
                        title: Text(
                          theme == ThemeModeEnum.light ? context.language.lightTheme : context.language.darkTheme,
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
                        onTap: () => Navigator.pop(context, theme),
                      ),
                      if (index < ThemeModeEnum.values.length - 1)
                        Divider(
                          color: context.theme.borderColor,
                          height: 1,
                          indent: 16,
                          endIndent: 16,
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
