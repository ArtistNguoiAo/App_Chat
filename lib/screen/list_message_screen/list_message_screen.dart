import 'package:app_chat/core/ext_context/ext_context.dart';
import 'package:app_chat/core/router/app_router.gr.dart';
import 'package:app_chat/core/utils/dialog_utils.dart';
import 'package:app_chat/core/utils/text_style_utils.dart';
import 'package:app_chat/core/widget/base_avatar.dart';
import 'package:app_chat/core/widget/base_loading.dart';
import 'package:app_chat/core/widget/base_text_field.dart';
import 'package:app_chat/data/model/chat_model.dart';
import 'package:app_chat/data/model/user_model.dart';
import 'package:app_chat/screen/list_message_screen/cubit/list_message_cubit.dart';
import 'package:auto_route/auto_route.dart';
import 'package:avatar_plus/avatar_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

@RoutePage()
class ListMessageScreen extends StatefulWidget {
  const ListMessageScreen({super.key});

  @override
  State<ListMessageScreen> createState() => _ListMessageScreenState();
}

class _ListMessageScreenState extends State<ListMessageScreen> with SingleTickerProviderStateMixin {
  final TextEditingController friendController = TextEditingController();
  final TextEditingController groupController = TextEditingController();
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ListMessageCubit()..getListUser(),
      child: BlocConsumer<ListMessageCubit, ListMessageState>(
        listener: (context, state) {
          if (state is ListMessageCreateGroupSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(context.language.createGroupSuccess),
              ),
            );
            context.read<ListMessageCubit>().getListUser();
          }
        },
        builder: (context, state) {
          if (state is ListMessageLoading) {
            return const Scaffold(body: BaseLoading());
          }
          if (state is ListMessageLoaded) {
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  context.language.message,
                  style: TextStyleUtils.bold(
                    fontSize: 20,
                    color: context.theme.backgroundColor,
                    context: context,
                  ),
                ),
                leading: InkWell(
                  onTap: () {
                    AutoRouter.of(context).maybePop();
                  },
                  child: Icon(
                    FontAwesomeIcons.chevronLeft,
                    color: context.theme.backgroundColor,
                    size: 18,
                  ),
                ),
                actions: [
                  PopupMenuButton(
                    icon: Icon(
                      FontAwesomeIcons.ellipsisVertical,
                      color: context.theme.backgroundColor,
                      size: 18,
                    ),
                    onSelected: (value) {
                      if (value == 1) {
                        AutoRouter.of(context).push(AddFriendRoute()).then((value) {
                          if (value != null && value == true) {
                            context.read<ListMessageCubit>().getListUser();
                          }
                        });
                      } else if (value == 2) {
                        DialogUtils.showListFriendDialog(
                          context: context,
                          listFriend: state.listFriend,
                          onSelected: (listFriend, groupName) {
                            context.read<ListMessageCubit>().createGroup(
                                  groupName: groupName,
                                  listUser: listFriend,
                                );
                          },
                        );
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 1,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              context.language.addFriend,
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              FontAwesomeIcons.userPlus,
                              color: context.theme.textColor,
                              size: 14,
                            ),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 2,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              context.language.addGroup,
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              FontAwesomeIcons.usersLine,
                              color: context.theme.textColor,
                              size: 14,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
                centerTitle: true,
                backgroundColor: context.theme.primaryColor,
                elevation: 0,
              ),
              body: Column(
                children: [
                  _tabBar(context),
                  Expanded(
                    child: _tabBarView(
                      context: context,
                      listChatFriend: state.listChatFriend,
                      listChatGroup: state.listChatGroup,
                      listFriend: state.listFriend,
                      currentUser: state.currentUser,
                    ),
                  ),
                ],
              ),
            );
          }
          return Container();
        },
      ),
    );
  }

  Widget _tabBar(BuildContext context) {
    return TabBar(
      controller: tabController,
      indicatorColor: context.theme.primaryColor,
      onTap: (index) {
        if (index == 0) {
          context.read<ListMessageCubit>().searchFriend(friendController.text);
        } else {
          context.read<ListMessageCubit>().searchGroup(groupController.text);
        }
      },
      tabs: [
        Tab(
          child: Text(
            context.language.friend,
            style: TextStyleUtils.bold(
              fontSize: 16,
              color: context.theme.textColor,
              context: context,
            ),
          ),
        ),
        Tab(
          child: Text(
            context.language.group,
            style: TextStyleUtils.bold(
              fontSize: 16,
              color: context.theme.textColor,
              context: context,
            ),
          ),
        ),
      ],
    );
  }

  Widget _tabBarView({
    required BuildContext context,
    required List<ChatModel> listChatFriend,
    required List<ChatModel> listChatGroup,
    required List<UserModel> listFriend,
    required UserModel currentUser,
  }) {
    return SizedBox(
      child: TabBarView(
        controller: tabController,
        children: [
          Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: context.theme.grey300Color,
                  borderRadius: BorderRadius.circular(32), // Độ bo góc
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                margin: const EdgeInsets.all(8),
                child: TextField(
                  controller: friendController,
                  onChanged: (value) {
                    context.read<ListMessageCubit>().searchFriend(value);
                  },
                  decoration: InputDecoration.collapsed(
                    hintText: context.language.search,
                    border: InputBorder.none,
                  ),
                ),
              ),
              Expanded(child: _listFriend(context, listFriend, listChatFriend, currentUser)),
            ],
          ),
          Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: context.theme.grey300Color,
                  borderRadius: BorderRadius.circular(32), // Độ bo góc
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                margin: const EdgeInsets.all(8),
                child: TextField(
                  controller: groupController,
                  onChanged: (value) {
                    context.read<ListMessageCubit>().searchGroup(value);
                  },
                  decoration: InputDecoration.collapsed(
                    hintText: context.language.search,
                    border: InputBorder.none,
                  ),
                ),
              ),
              Expanded(child: _listMessage(context, listChatGroup, currentUser)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _listFriend(BuildContext context, List<UserModel> listFriend, List<ChatModel> listChat, UserModel currentUser) {
    return ListView.separated(
      padding: const EdgeInsets.all(8),
      itemBuilder: (context, index) => InkWell(
        onTap: () {
          for (var element in listChat) {
            if (element.members.contains(listFriend[index].uid) && element.members.length == 2) {
              AutoRouter.of(context)
                  .push(
                MessageRoute(
                  chatModel: element,
                  friend: listFriend[index],
                ),
              )
                  .then((value) {
                if (value != null && value == true) {
                  context.read<ListMessageCubit>().getListUser();
                }
              });
              return;
            }
          }
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: context.theme.backgroundColor,
            boxShadow: [
              BoxShadow(
                color: context.theme.borderColor.withAlpha((0.5 * 255).round()),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Stack(
                children: [
                  BaseAvatar(
                    url: listFriend[index].avatar,
                    randomText: listFriend[index].uid,
                    size: 40,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: listFriend[index].status == 'online' ? context.theme.greenColor : context.theme.redColor,
                        border: Border.all(
                          color: context.theme.backgroundColor,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      listFriend[index].fullName,
                      style: TextStyleUtils.normal(
                        fontSize: 16,
                        color: context.theme.textColor,
                        context: context,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            listChat[index].lastMessageSenderId == currentUser.uid ? '${context.language.you}: ${listChat[index].lastMessage}' : listChat[index].lastMessage,
                            style: TextStyleUtils.normal(
                              fontSize: 12,
                              color: context.theme.textColor,
                              context: context,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          listChat[index].lastMessageTime.isNotEmpty ? DateFormat('yyyy-MM-dd hh:mm a').format(DateTime.parse(listChat[index].lastMessageTime)) : '',
                          style: TextStyleUtils.normal(
                            fontSize: 12,
                            color: context.theme.textColor,
                            context: context,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      separatorBuilder: (context, index) => Container(height: 4),
      itemCount: listFriend.length,
    );
  }

  Widget _listMessage(BuildContext context, List<ChatModel> listChat, UserModel currentUser) {
    return ListView.separated(
      padding: const EdgeInsets.all(8),
      itemBuilder: (context, index) => InkWell(
        onTap: () {
          AutoRouter.of(context).push(
            MessageRoute(
              chatModel: listChat[index],
            ),
          ).then((value) {
            if (value != null && value == true) {
              context.read<ListMessageCubit>().getListUser();
            }
          });
        },
        child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: context.theme.backgroundColor,
              boxShadow: [
                BoxShadow(
                  color: context.theme.borderColor.withAlpha((0.5 * 255).round()),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                BaseAvatar(
                  url: listChat[index].groupAvatar,
                  randomText: listChat[index].id,
                  size: 40,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        listChat[index].groupName,
                        style: TextStyleUtils.normal(
                          fontSize: 16,
                          color: context.theme.textColor,
                          context: context,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              listChat[index].lastMessageSenderId == currentUser.uid
                                  ? '${context.language.you}: ${listChat[index].lastMessage}'
                                  : '${listChat[index].lastMessageSenderName}: ${listChat[index].lastMessage}',
                              style: TextStyleUtils.normal(
                                fontSize: 12,
                                color: context.theme.textColor,
                                context: context,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            listChat[index].lastMessageTime.isNotEmpty ? DateFormat('yyyy-MM-dd hh:mm a').format(DateTime.parse(listChat[index].lastMessageTime)) : '',
                            style: TextStyleUtils.normal(
                              fontSize: 12,
                              color: context.theme.textColor,
                              context: context,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            )),
      ),
      separatorBuilder: (context, index) => Container(height: 4),
      itemCount: listChat.length,
    );
  }

  @override
  void dispose() {
    friendController.dispose();
    groupController.dispose();
    super.dispose();
  }
}
