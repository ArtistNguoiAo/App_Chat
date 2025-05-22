import 'package:app_chat/core/ext_context/ext_context.dart';
import 'package:app_chat/core/services/notification_service.dart'; // Import NotificationService
import 'package:app_chat/core/utils/media_utils.dart';
import 'package:app_chat/core/utils/text_style_utils.dart';
import 'package:app_chat/screen/auth/cubit/auth_cubit.dart';
import 'package:app_chat/screen/splash_screen/cubit/splash_cubit.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/router/app_router.gr.dart';

@RoutePage()
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isSplashTimeOver = false;
  bool _navigationAttempted = false; // To ensure navigation happens only once

  @override
  void initState() {
    super.initState();
  }

  void _navigateBasedOnAuth(BuildContext context) {
    // Renamed for clarity, this is the default navigation logic
    if (!mounted || _navigationAttempted) return;

    final authState = context.read<AuthCubit>().state;
    if (authState is AuthAuthenticated) {
      _navigationAttempted = true;
      AutoRouter.of(context).replace(const OverViewRoute());
    } else {
      _navigationAttempted = true;
      AutoRouter.of(context).replace(const LoginRoute());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplashCubit()..init(),
      child: MultiBlocListener(
        listeners: [
          BlocListener<SplashCubit, SplashState>(
            listener: (context, splashState) {
              if (splashState is SplashSuccess) {
                if (!mounted) return;
                setState(() {
                  _isSplashTimeOver = true;
                });

                if (_navigationAttempted) return; // Already navigated by AuthCubit or previous attempt

                // Check if app was opened from a terminated state notification
                final initialNotificationType = NotificationService.initialNotificationType;
                final initialNotificationPayload = NotificationService.initialNotificationPayload;

                if (initialNotificationType != null) {
                  _navigationAttempted = true;
                  final appRouter = AutoRouter.of(context);

                  // Clear the static flags after use
                  NotificationService.initialNotificationType = null;
                  NotificationService.initialNotificationPayload = null;

                  if (initialNotificationType == 'friend_request') {
                    appRouter.replace(const NotifyRoute());
                  } else if ((initialNotificationType == 'text' ||
                      initialNotificationType == 'image' ||
                      initialNotificationType == 'file') &&
                      initialNotificationPayload != null) {
                    appRouter.replace(MessageRoute(chatId: initialNotificationPayload));
                  } else {
                    _navigateBasedOnAuth(context);
                  }
                } else {
                  _navigateBasedOnAuth(context);
                }
              }
            },
          ),
          BlocListener<AuthCubit, AuthState>(
            listener: (context, authState) {
              if (!mounted) return;
              // Navigate based on auth state only if splash time is over AND no navigation has been attempted yet
              if (_isSplashTimeOver && !_navigationAttempted && (authState is AuthAuthenticated || authState is AuthUnauthenticated)) {
                _navigateBasedOnAuth(context);
              }
            },
          ),
        ],
        child: Scaffold(
          body: Column(
            children: [
              Expanded(
                child: Center(
                    child: SvgPicture.asset(
                      MediaUtils.imgLogo,
                      width: 160,
                      height: 160,
                    )
                        .animate()
                        .addEffect(
                      SlideEffect(
                        begin: const Offset(0, -1),
                        end: const Offset(0, 0),
                        duration: 1.seconds,
                        curve: Curves.easeInOut,
                      ),
                    )
                        .then()
                        .addEffect(const ShakeEffect(
                      duration: Duration(seconds: 1),
                      hz: 4,
                      curve: Curves.easeInOut,
                    ))),
              ),
              Text(
                'Developed by Nhom 11',
                style: TextStyleUtils.normal(
                  context: context,
                  color: context.theme.textColor,
                ),
              ).animate().addEffect(const FadeEffect(
                duration: Duration(seconds: 2), // This is animation duration, not splash delay
                begin: 0.0,
                end: 1.0,
              )),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}