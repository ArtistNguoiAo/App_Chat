import 'package:app_chat/core/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'core/router/app_router.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final AppRouter appRouter = AppRouter();
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: ColorUtils.yellowGold),
        useMaterial3: true,
      ),
      routerConfig: appRouter.config(),
      debugShowCheckedModeBanner: false,
    );
  }
}