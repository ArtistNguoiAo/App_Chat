import 'package:app_chat/core/ext_context/ext_context.dart';
import 'package:app_chat/core/router/app_router.gr.dart';
import 'package:app_chat/core/utils/dialog_utils.dart';
import 'package:app_chat/core/utils/text_style_utils.dart';
import 'package:app_chat/core/widget/base_loading.dart';
import 'package:app_chat/core/widget/base_text_field.dart';
import 'package:app_chat/data/model/user_model.dart';
import 'package:app_chat/screen/add_friend_screen/cubit/add_friend_cubit.dart';
import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:avatar_plus/avatar_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

@RoutePage()
class AddFriendScreen extends StatelessWidget {
  AddFriendScreen({super.key});

  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddFriendCubit()..getListUser(),
      child: BlocConsumer<AddFriendCubit, AddFriendState>(
        listener: (context, state) {
          if (state is AddFriendError) {
            DialogUtils.showErrorDialog(
              context: context,
              message: state.message,
            );
          }
        },
        builder: (context, state) {
          if (state is AddFriendLoading) {
            return const Scaffold(
              body: BaseLoading(),
            );
          }
          if (state is AddFriendLoaded) {
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  context.language.addFriend,
                  style: TextStyleUtils.bold(
                    fontSize: 20,
                    color: context.theme.backgroundColor,
                    context: context,
                  ),
                ),
                leading: InkWell(
                  onTap: () {
                    AutoRouter.of(context).maybePop(true);
                  },
                  child: Icon(
                    FontAwesomeIcons.chevronLeft,
                    color: context.theme.backgroundColor,
                    size: 18,
                  ),
                ),
                centerTitle: true,
                backgroundColor: context.theme.primaryColor,
                elevation: 0,
              ),
              body: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _searchBar(context, state.listUser, state.currentUser),
                    Expanded(
                      child: _listUser(context, state.listUser, state.currentUser),
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

  Widget _searchBar(BuildContext context, List<UserModel> listUser, UserModel currentUser) {
    return Row(
      children: [
        Expanded(
          child: BaseTextField(
            controller: searchController,
            prefixIcon: const Icon(Icons.search),
            fillColor: context.theme.backgroundColor,
            hintText: context.language.search,
            onChanged: (value) {
              context.read<AddFriendCubit>().searchUser(searchController.text);
            },
          ),
        ),
        const SizedBox(width: 16),
        InkWell(
          onTap: () {
            AutoRouter.of(context).push(const QrScannerRoute()).then(
              (value) {
                if (value != null) {
                  for(var user in listUser) {
                    if (user.uid == value && !currentUser.friends.contains(user.uid)) {
                      context.read<AddFriendCubit>().requestAddFriend(user);
                      return;
                    }
                  }
                }
              },
            );
          },
          child: Container(
            height: 48,
            width: 48,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: context.theme.primaryColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              FontAwesomeIcons.qrcode,
              color: Colors.white,
            ),
          ),
        )
      ],
    );
  }

  Widget _listUser(BuildContext context, List<UserModel> listUser, UserModel currentUser) {
    return ListView.separated(
      padding: const EdgeInsets.only(top: 16),
      itemBuilder: (context, index) {
        final isFriend = listUser[index].friends.contains(currentUser.uid);
        final isFriendRequest = listUser[index].friendRequests.contains(currentUser.uid);
        return InkWell(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onTap: () {
            DialogUtils.showUserInfoDialog(
              context: context,
              user: listUser[index],
              isFriend: isFriend,
              onDeleteFriend: () {
                DialogUtils.showConfirmDialog(
                  context: context,
                  content: context.language.deleteFriendContent,
                  confirmButton: context.language.delete,
                  onConfirm: () {
                    context.read<AddFriendCubit>().deleteFriend(listUser[index]);
                  },
                );
              },
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        listUser[index].fullName,
                        style: TextStyleUtils.bold(
                          fontSize: 16,
                          color: context.theme.textColor,
                          context: context,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        listUser[index].username,
                        style: TextStyleUtils.normal(
                          fontSize: 14,
                          color: context.theme.textColor,
                          context: context,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: context.theme.borderColor,
                    ),
                  ),
                  child: InkWell(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () {
                      if (isFriendRequest) {
                        context.read<AddFriendCubit>().unRequestAddFriend(listUser[index]);
                      } else {
                        if (!isFriend) {
                          context.read<AddFriendCubit>().requestAddFriend(listUser[index]);
                        }
                      }
                    },
                    child: FaIcon(
                      isFriend
                          ? FontAwesomeIcons.userGroup
                          : isFriendRequest
                              ? FontAwesomeIcons.userCheck
                              : FontAwesomeIcons.userPlus,
                      color: isFriend
                          ? context.theme.blueColor
                          : isFriendRequest
                              ? context.theme.blueColor
                              : context.theme.borderColor,
                      size: 16,
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => const Divider(),
      itemCount: listUser.length,
    );
  }
}
