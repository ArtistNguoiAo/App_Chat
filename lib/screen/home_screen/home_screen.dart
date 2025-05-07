import 'package:app_chat/core/ext_context/ext_context.dart';
import 'package:app_chat/core/utils/text_style_utils.dart';
import 'package:app_chat/data/model/user_model.dart';
import 'package:app_chat/screen/auth/cubit/auth_cubit.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../core/router/app_router.gr.dart';

@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Kiểm tra trạng thái xác thực khi màn hình được tạo
    context.read<AuthCubit>().checkAuthState();
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading || state is AuthInitial) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state is AuthUnauthenticated) {
          context.router.replace(const LoginRoute());
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state is AuthAuthenticated) {
          final user = state.user;
          return Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  _header(user),
                  const SizedBox(height: 16),
                  _recentChat(context),
                  const SizedBox(height: 16),
                  _favoriteChat(context),
                ],
              ),
            ),
          );
        }
        return const SizedBox();
      },
    );
  }

  Widget _header(UserModel user) {
    return Builder(builder: (context) {
      return SizedBox(
        height: 200,
        child: Stack(
          children: [
            Container(
                height: 150,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                width: double.infinity,
                color: context.theme.primaryColor,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            context.language.welcomeApp,
                            style: TextStyleUtils.bold(
                              fontSize: 20,
                              color: context.theme.backgroundColor,
                              context: context,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        InkWell(
                          onTap: () {},
                          child: FaIcon(
                            FontAwesomeIcons.bell,
                            color: context.theme.backgroundColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      context.language.introduceBot,
                      style: TextStyleUtils.normal(
                        fontSize: 16,
                        color: context.theme.backgroundColor,
                        context: context,
                      ),
                    ),
                  ],
                )),
            Positioned(
              top: 100,
              left: 16,
              child: InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () {},
                child: Container(
                  height: 100,
                  padding: const EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width - 32,
                  decoration: BoxDecoration(
                    color: context.theme.backgroundColor,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: context.theme.borderColor.withAlpha((0.5 * 255).round()),
                        spreadRadius: 2,
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: context.theme.borderColor,
                          image: DecorationImage(
                            image: NetworkImage(user.avatar ?? ''),
                            fit: BoxFit.cover,
                            onError: (error, stackTrace) => const Icon(Icons.person),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              child: Text(
                                '${context.language.hello},',
                                style: TextStyleUtils.normal(
                                  fontSize: 16,
                                  color: context.theme.textColor,
                                  context: context,
                                ),
                              ),
                            ),
                            Flexible(
                              child: Text(
                                user.fullName,
                                style: TextStyleUtils.bold(
                                  fontSize: 20,
                                  color: context.theme.textColor,
                                  context: context,
                                ),
                              ),
                            ),
                            Flexible(
                              child: Text(
                                '${context.language.haveAGoodDay}!',
                                style: TextStyleUtils.normal(
                                  fontSize: 16,
                                  color: context.theme.textColor,
                                  context: context,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      FaIcon(
                        FontAwesomeIcons.feather,
                        color: context.theme.textColor,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _recentChat(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            context.language.recentChat,
            style: TextStyleUtils.bold(
              fontSize: 20,
              color: context.theme.textColor,
              context: context,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _itemRecentChat(context),
              _itemRecentChat(context),
              _itemRecentChat(context),
            ],
          )
        ],
      ),
    );
  }

  Widget _itemRecentChat(BuildContext context) {
    return InkWell(
      onTap: () {

      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.theme.backgroundColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.theme.borderColor,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'User Name',
              style: TextStyleUtils.bold(
                fontSize: 16,
                color: context.theme.textColor,
                context: context,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _favoriteChat(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            context.language.favoriteChat,
            style: TextStyleUtils.bold(
              fontSize: 20,
              color: context.theme.textColor,
              context: context,
            ),
          ),
          const SizedBox(height: 16),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _itemFavoriteChat(context),
              const SizedBox(height: 8),
              _itemFavoriteChat(context),
              const SizedBox(height: 8),
              _itemFavoriteChat(context),
            ],
          )
        ],
      ),
    );
  }

  Widget _itemFavoriteChat(BuildContext context) {
    return InkWell(
      onTap: () {

      },
      child: Container(
        padding: const EdgeInsets.all(16),
        width: double.infinity,
        decoration: BoxDecoration(
          color: context.theme.backgroundColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.theme.borderColor,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              'User Name',
              style: TextStyleUtils.bold(
                fontSize: 16,
                color: context.theme.textColor,
                context: context,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
