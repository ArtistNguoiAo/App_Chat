import 'package:app_chat/core/ext_context/ext_context.dart';
import 'package:app_chat/core/utils/text_style_utils.dart';
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
                        _header(authState.user, isLoading: true),
                        const Expanded(
                          child: Center(child: CircularProgressIndicator()),
                        ),
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
                    body: RefreshIndicator(
                      onRefresh: () async {
                        homeContext.read<HomeCubit>().loadHomeData();
                      },
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(
                          children: [
                            _header(homeState.currentUser),
                            const SizedBox(height: 16),
                            _recentChat(homeContext, homeState.recentChats, homeState.allUsersMap, homeState.currentUser),
                            const SizedBox(height: 16),
                            _favoriteChat(homeContext, homeState.favoriteChats, homeState.allUsersMap, homeState.currentUser),
                          ],
                        ),
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

  Widget _header(UserModel user, {bool isLoading = false}) {
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
                          onTap: () {
                            AutoRouter.of(context).push(const NotifyRoute());
                          },
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
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isLoading ? context.theme.borderColor.withOpacity(0.5) : context.theme.borderColor,
                          image: isLoading || user.avatar.isEmpty
                              ? null
                              : DecorationImage(
                                  image: NetworkImage(user.avatar),
                                  fit: BoxFit.cover,
                                  onError: (error, stackTrace) => const Icon(Icons.person_outline, size: 40),
                                ),
                        ),
                        child: isLoading && user.avatar.isEmpty ? const Center(child: Icon(Icons.person_outline, size: 40)) : null,
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

  Widget _recentChat(BuildContext context, List<ChatModel> recentChats, Map<String, UserModel> allUsersMap, UserModel currentUser) {
    if (recentChats.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.language.recentChat,
              style: TextStyleUtils.bold(fontSize: 20, color: context.theme.textColor, context: context),
            ),
            const SizedBox(height: 8),
            Text(
              "No recent chats.",
              style: TextStyleUtils.normal(fontSize: 16, color: context.theme.textColor.withOpacity(0.7), context: context),
            ),
          ],
        ),
      );
    }
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
          SizedBox(
            height: 130,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: recentChats.length,
              separatorBuilder: (context, index) => const SizedBox(width: 12),
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
                final displayName = chat.type == 'group' ? chat.groupName : (otherUser?.username ?? 'Unknown User');
                final displayAvatar = chat.type == 'group' ? chat.groupAvatar : (otherUser?.avatar ?? '');

                return _itemRecentChat(context, displayName, displayAvatar, chat);
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _itemRecentChat(BuildContext context, String name, String avatarUrl, ChatModel chat) {
    return InkWell(
      onTap: () {
        AutoRouter.of(context).push(MessageRoute(chatModel: chat));
      },
      child: Container(
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
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.theme.borderColor,
                image: avatarUrl.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(avatarUrl),
                        fit: BoxFit.cover,
                        onError: (e, s) => const Icon(Icons.group_outlined),
                      )
                    : null,
              ),
              child: avatarUrl.isEmpty ? Icon(chat.type == 'group' ? Icons.group_outlined : Icons.person_outline, size: 30) : null,
            ),
            const SizedBox(height: 8),
            Text(
              name,
              textAlign: TextAlign.center,
              maxLines: 2,
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
    );
  }

  Widget _favoriteChat(BuildContext context, List<ChatModel> favoriteChats, Map<String, UserModel> allUsersMap, UserModel currentUser) {
    if (favoriteChats.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.language.favoriteChat,
              style: TextStyleUtils.bold(fontSize: 20, color: context.theme.textColor, context: context),
            ),
            const SizedBox(height: 8),
            Text(
              "No favorite chats yet.",
              style: TextStyleUtils.normal(fontSize: 16, color: context.theme.textColor.withOpacity(0.7), context: context),
            ),
          ],
        ),
      );
    }
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
              final displayName = chat.type == 'group' ? chat.groupName : (otherUser?.username ?? 'Unknown User');
              final displayAvatar = chat.type == 'group' ? chat.groupAvatar : (otherUser?.avatar ?? '');
              return _itemFavoriteChat(context, displayName, displayAvatar, chat);
            },
          )
        ],
      ),
    );
  }

  Widget _itemFavoriteChat(BuildContext context, String name, String avatarUrl, ChatModel chat) {
    return InkWell(
      onTap: () {
        AutoRouter.of(context).push(MessageRoute(chatModel: chat));
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
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.theme.borderColor,
                image: avatarUrl.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(avatarUrl),
                        fit: BoxFit.cover,
                        onError: (e, s) => const Icon(Icons.group_outlined),
                      )
                    : null,
              ),
              child: avatarUrl.isEmpty ? Icon(chat.type == 'group' ? Icons.group_outlined : Icons.person_outline, size: 30) : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyleUtils.bold(
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
