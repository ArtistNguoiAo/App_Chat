import 'package:app_chat/core/ext_context/ext_context.dart';
import 'package:app_chat/core/router/app_router.gr.dart';
import 'package:app_chat/core/utils/dialog_utils.dart';
import 'package:app_chat/core/utils/text_style_utils.dart';
import 'package:app_chat/core/widget/base_loading.dart';
import 'package:app_chat/core/widget/base_text_field.dart';
import 'package:app_chat/data/model/user_model.dart';
import 'package:app_chat/screen/list_message_screen/cubit/list_message_cubit.dart';
import 'package:auto_route/auto_route.dart';
import 'package:avatar_plus/avatar_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

@RoutePage()
class ListMessageScreen extends StatelessWidget {
  ListMessageScreen({super.key});

  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ListMessageCubit()..getListUser(),
      child: BlocConsumer<ListMessageCubit, ListMessageState>(
        listener: (context, state) {
          if(state is ListMessageCreateGroupSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(context.language.createGroupSuccess),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ListMessageLoading) {
            return const Scaffold(
              body: BaseLoading()
            );
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
                  InkWell(
                    onTap: () {
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
                    },
                    child: Icon(
                      FontAwesomeIcons.usersLine,
                      color: context.theme.backgroundColor,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 20),
                ],
                centerTitle: true,
                backgroundColor: context.theme.primaryColor,
                elevation: 0,
              ),
              body: Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 16,
                  left: 16,
                  right: 16,
                  bottom: 16,
                ),
                child: Column(
                  children: [
                    _searchBar(context),
                    Expanded(
                      child: _listMessage(context, state.listUser, state.currentUser),
                    ),
                  ],
                ),
              ),
            );
          }
          return Container();
        },
      ),
    );
  }

  Widget _searchBar(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: BaseTextField(
            controller: searchController,
            prefixIcon: const Icon(Icons.search),
            hintText: context.language.search,
          ),
        ),
        const SizedBox(width: 8),
        InkWell(
          onTap: () {
            AutoRouter.of(context).push(AddFriendRoute());
          },
          child: Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: context.theme.primaryColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: context.theme.primaryColor,
              ),
            ),
            child: const Icon(
              FontAwesomeIcons.userPlus,
              color: Colors.white,
              size: 18,
            ),
          ),
        )
      ],
    );
  }

  Widget _listMessage(BuildContext context, List<UserModel> listUser, UserModel currentUser) {
    return ListView.separated(
      padding: const EdgeInsets.only(top: 16),
      itemBuilder: (context, index) => InkWell(
        onTap: () {
          AutoRouter.of(context).push(
            MessageRoute(
              listOtherUser: [listUser[index]],
              currentUser: currentUser,
            ),
          );
        },
        child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                listUser[index].avatar.isNotEmpty
                    ? Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: context.theme.borderColor,
                        ),
                        child: ClipOval(
                          child: Image.network(
                            listUser[index].avatar,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    : AvatarPlus(
                        listUser[index].uid,
                        height: 60,
                        width: 60,
                      ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${listUser[index].firstName} ${listUser[index].lastName}',
                      style: TextStyleUtils.bold(
                        fontSize: 16,
                        color: context.theme.textColor,
                        context: context,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      listUser[index].email,
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
      separatorBuilder: (context, index) => const Divider(),
      itemCount: listUser.length,
    );
  }
}
