import 'package:app_chat/core/ext_context/ext_context.dart';
import 'package:app_chat/core/router/app_router.gr.dart';
import 'package:app_chat/core/utils/dialog_utils.dart';
import 'package:app_chat/core/utils/text_style_utils.dart';
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

@RoutePage()
class ListMessageScreen extends StatefulWidget {
  const ListMessageScreen({super.key});

  @override
  State<ListMessageScreen> createState() => _ListMessageScreenState();
}

class _ListMessageScreenState extends State<ListMessageScreen> with SingleTickerProviderStateMixin {
  final TextEditingController searchController = TextEditingController();
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
                        AutoRouter.of(context).push(AddFriendRoute());
                      } else if (value == 2) {
                        DialogUtils.showListFriendDialog(
                          context: context,
                          listFriend: state.listUser,
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
                        child: Text(
                          context.language.addFriend,
                        ),
                      ),
                      PopupMenuItem(
                        value: 2,
                        child: Text(
                          context.language.addGroup,
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
                  Expanded(child: _tabBarView(context, state.listChatFriend, state.listChatGroup)),
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

  Widget _tabBarView(BuildContext context, List<ChatModel> listChatFriend, List<ChatModel> listChatGroup) {
    return SizedBox(
      child: TabBarView(
        controller: tabController,
        children: [
          _listMessage(context, listChatFriend),
          _listMessage(context, listChatGroup),
        ],
      ),
    );
  }

  Widget _listMessage(BuildContext context, List<ChatModel> listChat) {
    return ListView.separated(
      padding: const EdgeInsets.all(8),
      itemBuilder: (context, index) => InkWell(
        onTap: () {
          AutoRouter.of(context).push(
            MessageRoute(
              chatModel: listChat[index],
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: context.theme.backgroundColor,
              boxShadow: [
                BoxShadow(
                  color: context.theme.borderColor.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                listChat[index].groupAvatar.isNotEmpty
                    ? Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: context.theme.borderColor,
                        ),
                        child: ClipOval(
                          child: Image.network(
                            listChat[index].groupAvatar,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    : AvatarPlus(
                        listChat[index].groupName,
                        height: 40,
                        width: 40,
                      ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      listChat[index].groupName,
                      style: TextStyleUtils.bold(
                        fontSize: 16,
                        color: context.theme.textColor,
                        context: context,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      listChat[index].lastMessageId,
                      style: TextStyleUtils.normal(
                        fontSize: 14,
                        color: context.theme.textColor,
                        context: context,
                      ),
                    ),
                  ],
                ),
              ],
            )),
      ),
      separatorBuilder: (context, index) => Container(height: 4),
      itemCount: listChat.length,
    );
  }
}
