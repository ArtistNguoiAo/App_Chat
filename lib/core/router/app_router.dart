import 'package:auto_route/auto_route.dart';

import 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends $AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: SplashRoute.page, initial: true, path: '/splash'),
        AutoRoute(page: LoginRoute.page, path: '/login'),
        AutoRoute(page: RegisterRoute.page, path: '/register'),
        AutoRoute(
          page: OverViewRoute.page,
          path: '/over-view',
          children: [
            AutoRoute(page: HomeRoute.page, path: 'home'),
            AutoRoute(page: ProfileRoute.page, path: 'profile'),
          ],
        ),
        AutoRoute(page: ListMessageRoute.page, path: '/list-message'),
        AutoRoute(page: LanguageSettingRoute.page, path: '/change-language'),
        AutoRoute(page: ThemeSettingRoute.page, path: '/change-theme'),
        AutoRoute(page: UpdateProfileRoute.page, path: '/update-profile'),
        AutoRoute(page: ChangePasswordRoute.page, path: '/change-password'),
        AutoRoute(page: ForgotPasswordRoute.page, path: '/forgot-password'),
        AutoRoute(
          page: MessageRoute.page,
          path: '/message/:chatId',
        ),
        AutoRoute(page: AddFriendRoute.page, path: '/add-friend'),
        AutoRoute(page: NotifyRoute.page, path: '/notify'),
        AutoRoute(page: QrScannerRoute.page, path: '/qr-scanner'),
      ];
}
