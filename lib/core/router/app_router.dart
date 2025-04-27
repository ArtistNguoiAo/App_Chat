import 'package:auto_route/auto_route.dart';

import 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends $AppRouter {
  @override
  List<AutoRoute> get routes =>
      [
        AutoRoute(page: LoginRoute.page, path: '/login'),
        AutoRoute(page: RegisterRoute.page, path: '/register'),
        AutoRoute(page: OverViewRoute.page, path: '/over-view'),
        AutoRoute(page: LanguageSettingRoute.page, path: '/change-language'),
        AutoRoute(page: ThemeSettingRoute.page, path: '/change-theme'),
      ];
}
