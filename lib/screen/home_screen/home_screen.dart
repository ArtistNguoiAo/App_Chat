import 'package:app_chat/core/ext_context/ext_context.dart';
import 'package:app_chat/core/utils/text_style_utils.dart';
import 'package:app_chat/core/widget/base_avatar.dart';
import 'package:app_chat/core/widget/base_loading.dart';
import 'package:app_chat/data/model/chat_model.dart';
import 'package:app_chat/data/model/user_model.dart';
import 'package:app_chat/screen/auth/cubit/auth_cubit.dart';
import 'package:app_chat/screen/home_screen/cubit/home_cubit.dart';
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
    context.read<AuthCubit>().checkAuthState();
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, authState) {
        if (authState is AuthLoading || authState is AuthInitial) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (authState is AuthUnauthenticated) {
          context.router.replace(const LoginRoute());
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (authState is AuthAuthenticated) {
          return BlocProvider(
            create: (homeContext) => HomeCubit()..loadHomeData(),
            child: BlocBuilder<HomeCubit, HomeState>(
              builder: (homeContext, homeState) {
                if (homeState is HomeLoading || homeState is HomeInitial) {
                  return Scaffold(
                    body: Column(
                      children: [
                        _header(authState.user, null, isLoading: true),
                        const Expanded(child: BaseLoading()),
                      ],
                    ),
                  );
                }

                if (homeState is HomeError) {
                  return Scaffold(
                    body: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Error: ${homeState.message}'),
                          ElevatedButton(
                            onPressed: () => homeContext.read<HomeCubit>().loadHomeData(),
                            child: const Text('Retry'),
                          )
                        ],
                      ),
                    ),
                  );
                }

                if (homeState is HomeLoaded) {
                  return Scaffold(
                    body: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _header(homeState.currentUser, homeState.currentUser),
                          const SizedBox(height: 16),
                          _recentChat(
                            context: homeContext,
                            recentChats: homeState.recentChats,
                            allUsersMap: homeState.allUsersMap,
                            currentUser: homeState.currentUser,
                          ),
                          const SizedBox(height: 16),
                          _favoriteChat(
                            context: homeContext,
                            favoriteChats: homeState.favoriteChats,
                            allUsersMap: homeState.allUsersMap,
                            currentUser: homeState.currentUser,
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          );
        }
        return const Scaffold(body: Center(child: Text("Unexpected Auth State")));
      },
    );
  }

  Widget _header(UserModel user, UserModel? currentUser, {bool isLoading = false}) {
    return Builder(builder: (context) {
      return SizedBox(
        height: 200 + MediaQuery.of(context).padding.top,
        child: Stack(
          children: [
            Container(
                height: 150 + MediaQuery.of(context).padding.top,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                width: double.infinity,
                color: context.theme.primaryColor,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: MediaQuery.of(context).padding.top),
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
                          onTap: () {
                            AutoRouter.of(context).push(const NotifyRoute());
                          },
                          child: Stack(
                            children: [
                              FaIcon(
                                Icons.notifications,
                                color: context.theme.backgroundColor,
                                size: 28,
                              ),
                              if ((currentUser?.friendRequests ?? []).isNotEmpty)
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  child: Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: context.theme.redColor,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                            ],
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
              top: 100 + MediaQuery.of(context).padding.top,
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
                      BaseAvatar(
                        url: user.avatar,
                        randomText: user.uid,
                        size: 80,
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
                                isLoading ? "Loading..." : user.fullName,
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

  Widget _recentChat({
    required BuildContext context,
    required List<ChatModel> recentChats,
    required Map<String, UserModel> allUsersMap,
    required UserModel currentUser,
  }) {
    if (recentChats.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.language.recentChat,
              style: TextStyleUtils.bold(
                fontSize: 20,
                color: context.theme.textColor,
                context: context,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              context.language.noRecentChat,
              style: TextStyleUtils.normal(
                fontSize: 16,
                color: context.theme.textColor,
                context: context,
              ),
            ),
          ],
        ),
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              context.language.recentChat,
              style: TextStyleUtils.bold(
                fontSize: 20,
                color: context.theme.textColor,
                context: context,
              ),
            ),
          ),
          SizedBox(
            height: 164,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: recentChats.length,
              separatorBuilder: (context, index) => const SizedBox(width: 12),
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                final chat = recentChats[index];
                UserModel? otherUser;
                String otherUserId = '';
                if (chat.type == 'private' && chat.members.length >= 2) {
                  otherUserId = chat.members.firstWhere((id) => id != currentUser.uid, orElse: () => '');
                  if (otherUserId.isNotEmpty) {
                    otherUser = allUsersMap[otherUserId];
                  }
                }
                final displayName = chat.type == 'group' ? chat.groupName : (otherUser?.fullName ?? 'Unknown User');
                final displayAvatar = chat.type == 'group' ? chat.groupAvatar : (otherUser?.avatar ?? '');
                final displayId = chat.type == 'group' ? chat.id : (otherUser?.uid ?? '');

                return _itemRecentChat(
                  context: context,
                  name: displayName,
                  avatarUrl: displayAvatar,
                  id: displayId,
                  chat: chat,
                  user: otherUser,
                );
              },
            ),
          )
        ],
      );
    }
  }

  Widget _itemRecentChat({
    required BuildContext context,
    required String name,
    required String avatarUrl,
    required String id,
    required ChatModel chat,
    required UserModel? user,
  }) {
    return InkWell(
      onTap: () {
        if (user != null) {
          AutoRouter.of(context).push(MessageRoute(friend: user, chatModel: chat));
        } else {
          AutoRouter.of(context).push(MessageRoute(chatModel: chat));
        }
      },
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: Icon(
              Icons.check_circle,
              color: context.theme.primaryColor,
              size: 20,
            ),
          ),
          Container(
            width: 100,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: context.theme.backgroundColor,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: context.theme.borderColor.withAlpha(100),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BaseAvatar(
                  url: avatarUrl,
                  randomText: id,
                  size: 50,
                ),
                const SizedBox(height: 8),
                Text(
                  name,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyleUtils.normal(
                    fontSize: 14,
                    color: context.theme.textColor,
                    context: context,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _favoriteChat({
    required BuildContext context,
    required List<ChatModel> favoriteChats,
    required Map<String, UserModel> allUsersMap,
    required UserModel currentUser,
  }) {
    if (favoriteChats.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.language.favoriteChat,
              style: TextStyleUtils.bold(
                fontSize: 20,
                color: context.theme.textColor,
                context: context,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              context.language.noFavoriteChat,
              style: TextStyleUtils.normal(
                fontSize: 16,
                color: context.theme.textColor,
                context: context,
              ),
            ),
          ],
        ),
      );
    } else {
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
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 16),
              itemCount: favoriteChats.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final chat = favoriteChats[index];
                UserModel? otherUser;
                String otherUserId = '';
                if (chat.type == 'private' && chat.members.length >= 2) {
                  otherUserId = chat.members.firstWhere((id) => id != currentUser.uid, orElse: () => '');
                  if (otherUserId.isNotEmpty) {
                    otherUser = allUsersMap[otherUserId];
                  }
                }
                final displayName = chat.type == 'group' ? chat.groupName : (otherUser?.fullName ?? 'Unknown User');
                final displayAvatar = chat.type == 'group' ? chat.groupAvatar : (otherUser?.avatar ?? '');
                final displayId = chat.type == 'group' ? chat.id : (otherUser?.uid ?? '');
                return _itemFavoriteChat(
                  context: context,
                  name: displayName,
                  avatarUrl: displayAvatar,
                  id: displayId,
                  chat: chat,
                  user: otherUser
                );
              },
            )
          ],
        ),
      );
    }
  }

  Widget _itemFavoriteChat({
    required BuildContext context,
    required String name,
    required String avatarUrl,
    required String id,
    required ChatModel chat,
    required UserModel? user,
  }) {
    return InkWell(
      onTap: () {
        if(user != null) {
          AutoRouter.of(context).push(MessageRoute(friend: user, chatModel: chat));
        }
        else {
          AutoRouter.of(context).push(MessageRoute(chatModel: chat));
        }
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        width: double.infinity,
        decoration: BoxDecoration(
          color: context.theme.backgroundColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: context.theme.borderColor.withAlpha(100),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            BaseAvatar(
              url: avatarUrl,
              randomText: id,
              size: 50,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
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
    );
  }
}
