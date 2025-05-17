import 'package:app_chat/core/ext_context/ext_context.dart';
import 'package:app_chat/core/language/cubit/language_cubit.dart';
import 'package:app_chat/core/language/inherited_language_widget.dart';
import 'package:app_chat/core/theme/cubit/theme_cubit.dart';
import 'package:app_chat/core/theme/inherited_theme_widget.dart';
import 'package:app_chat/screen/auth/cubit/auth_cubit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/di/config_di.dart';
import 'core/router/app_router.dart';
import 'core/router/app_router.gr.dart';
import 'data/local_cache.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await LocalCache.init();
  ConfigDI();
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
          create: (context) => LanguageCubit()..init(),
        ),
        BlocProvider<ThemeCubit>(
          create: (context) => ThemeCubit()..init(),
        ),
        BlocProvider<AuthCubit>(
          create: (context) => AuthCubit()..checkAuthState(),
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
                      colorScheme: ColorScheme.fromSeed(seedColor: context.theme.borderColor),
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
