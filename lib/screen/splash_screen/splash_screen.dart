import 'package:app_chat/core/ext_context/ext_context.dart';
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
  bool _navigationAttempted = false;

  @override
  void initState() {
    super.initState();
    // AuthCubit is provided by MyApp and its checkAuthState is called there.
    // We listen to it here to coordinate navigation with the splash duration.
  }

  void _navigate(BuildContext context) {
    if (!mounted || _navigationAttempted) return;

    final authState = context.read<AuthCubit>().state;
    if (authState is AuthAuthenticated) {
      _navigationAttempted = true;
      AutoRouter.of(context).replace(const OverViewRoute());
    } else if (authState is AuthUnauthenticated) {
      _navigationAttempted = true;
      AutoRouter.of(context).replace(const LoginRoute());
    }
    // If authState is AuthInitial or AuthLoading, we wait.
    // The AuthCubit listener will call _navigate again when the state changes.
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
                // Attempt navigation now that splash time is over
                _navigate(context);
              }
            },
          ),
          BlocListener<AuthCubit, AuthState>(
            // Listens to the globally provided AuthCubit
            listener: (context, authState) {
              if (!mounted) return;
              // Attempt navigation if splash time is over and auth state is conclusive
              if (_isSplashTimeOver && (authState is AuthAuthenticated || authState is AuthUnauthenticated)) {
                _navigate(context);
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
                'Developed by Le Quoc Trung',
                style: TextStyleUtils.normal(
                  context: context,
                  color: context.theme.textColor,
                ),
              ).animate().addEffect(const FadeEffect(
                    duration: Duration(seconds: 2),
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
