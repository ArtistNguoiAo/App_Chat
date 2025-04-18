import 'package:app_chat/core/ext_context/ext_context.dart';
import 'package:app_chat/core/language/cubit/language_cubit.dart';
import 'package:app_chat/core/language/inherited_language_widget.dart';
import 'package:app_chat/core/theme/cubit/theme_cubit.dart';
import 'package:app_chat/core/theme/inherited_theme_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/router/app_router.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final AppRouter appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LanguageCubit>(
          create: (context) => LanguageCubit(),
        ),
        BlocProvider<ThemeCubit>(
          create: (context) => ThemeCubit(),
        ),
      ],
      child: BlocBuilder<LanguageCubit, LanguageState>(
        builder: (context, languageState) {
          return InheritedLanguageWidget(
            languageModeEnum: languageState.languageModeEnum,
            child: BlocBuilder<ThemeCubit, ThemeState>(
              builder: (context, themeState) {
                return InheritedThemeWidget(
                  themeModeEnum: themeState.themeModeEnum,
                  child: MaterialApp.router(
                    theme: ThemeData(
                      colorScheme: ColorScheme.fromSeed(seedColor: context.theme.yellowGold),
                      useMaterial3: true,
                    ),
                    routerConfig: appRouter.config(),
                    debugShowCheckedModeBanner: false,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
