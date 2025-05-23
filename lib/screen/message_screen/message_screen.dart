import 'dart:io';

import 'package:app_chat/core/ext_context/ext_context.dart';
import 'package:app_chat/core/utils/dialog_utils.dart';
import 'package:app_chat/core/utils/text_style_utils.dart';
import 'package:app_chat/core/widget/base_avatar.dart';
import 'package:app_chat/core/widget/base_text_field.dart';
import 'package:app_chat/data/model/chat_model.dart';
import 'package:app_chat/data/model/message_model.dart';
import 'package:app_chat/data/model/user_model.dart';
import 'package:app_chat/data/repository/auth_repository.dart';
import 'package:app_chat/screen/message_screen/cubit/message_cubit.dart';
import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:avatar_plus/avatar_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../core/router/app_router.gr.dart';

@RoutePage()
class MessageScreen extends StatefulWidget {
  const MessageScreen({
    super.key,
    @PathParam('chatId') this.chatId,
    this.chatModel,
    this.friend,
  });

  final String? chatId;
  final ChatModel? chatModel;
  final UserModel? friend;

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final _messageController = TextEditingController();
  ChatModel? _chatModel;
  UserModel? _friend;
  String? _updatedGroupName;
  String? _updatedGroupAvatar;

  @override
  void initState() {
    super.initState();
    _loadChatData();
  }

  Future<File?> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    return pickedFile != null ? File(pickedFile.path) : null;
  }

  Future<File?> _takeImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    return pickedFile != null ? File(pickedFile.path) : null;
  }

  Future<void> _loadChatData() async {
    if (widget.chatId != null && widget.chatModel == null) {
      final chatDoc = await FirebaseFirestore.instance.collection('chats').doc(widget.chatId).get();

      if (chatDoc.exists) {
        setState(() {
          _chatModel = ChatModel.fromMap(chatDoc.data()!);
        });

        if (_chatModel!.type == 'private') {
          final otherUserId = _chatModel!.members.firstWhere((id) => id != FirebaseAuth.instance.currentUser?.uid);

          final userDoc = await FirebaseFirestore.instance.collection('users').doc(otherUserId).get();

          if (userDoc.exists) {
            setState(() {
              _friend = UserModel.fromMap(userDoc.data()!);
            });
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print('Chat ID: ${widget.chatId}');
    final chatModel = widget.chatModel ?? _chatModel;
    final friend = widget.friend ?? _friend;

    if (chatModel == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return BlocProvider(
      create: (context) => MessageCubit()
        ..loadMessage(
          chatId: chatModel.id,
          seenBy: chatModel.members,
        ),
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              widget.friend != null
                  ? BaseAvatar(
                      url: widget.friend!.avatar,
                      randomText: widget.friend!.uid,
                      size: 40,
                    )
                  : BaseAvatar(
                      url: _updatedGroupAvatar ?? chatModel.groupAvatar,
                      randomText: chatModel.id,
                      size: 40,
                    ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.friend != null ? widget.friend!.fullName : (_updatedGroupName ?? chatModel.groupName),
                      style: TextStyleUtils.bold(
                        fontSize: 20,
                        color: context.theme.backgroundColor,
                        context: context,
                      ),
                    ),
                    widget.friend == null
                        ? const SizedBox()
                        : Text(
                            widget.friend!.status,
                            style: TextStyleUtils.normal(
                              fontSize: 14,
                              color: widget.friend!.status == 'online' ? context.theme.backgroundColor : context.theme.textColor,
                              context: context,
                            ),
                          ),
                  ],
                ),
              ),
            ],
          ),
          leading: InkWell(
            onTap: () async {
              final router = AutoRouter.of(context);
              final didPop = await router.maybePop(true);
              if (!didPop && mounted) {
                router.replace(const OverViewRoute());
              }
            },
            child: Icon(
              FontAwesomeIcons.chevronLeft,
              color: context.theme.backgroundColor,
              size: 18,
            ),
          ),
          actions: [
            Builder(builder: (context) {
              return InkWell(
                onTap: () async {
                  if (widget.friend != null) {
                    DialogUtils.showUserInfoDialog(
                      context: context,
                      user: widget.friend!,
                      isFriend: true,
                      onDeleteFriend: () {
                        DialogUtils.showConfirmDialog(
                          context: context,
                          content: context.language.deleteFriendContent,
                          confirmButton: context.language.delete,
                          onConfirm: () {
                            context.read<MessageCubit>().deleteFriend(
                                  userModel: widget.friend!,
                                  chatId: chatModel.id,
                                );
                          },
                        );
                      },
                    );
                  } else {
                    final AuthRepository authRepository = GetIt.instance<AuthRepository>();
                    final list = await authRepository.getAll();
                    final listMember = list.where((user) => widget.chatModel!.members.contains(user.uid)).toList();
                    DialogUtils.showGroupInfoDialog(
                      context: context,
                      chat: chatModel,
                      listMember: listMember,
                      onFunction: (groupName, groupAvatar) {
                        context.read<MessageCubit>().updateGroup(
                              chatId: widget.chatModel?.id ?? '',
                              groupName: groupName,
                              groupAvatar: groupAvatar,
                            );
                      },
                    );
                  }
                },
                child: Icon(
                  FontAwesomeIcons.circleInfo,
                  color: context.theme.backgroundColor,
                  size: 18,
                ),
              );
            }),
            const SizedBox(width: 16),
          ],
          backgroundColor: context.theme.primaryColor,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: BlocConsumer<MessageCubit, MessageState>(
            listener: (context, state) {
              if (state is MessageDeleteSuccess) {
                AutoRouter.of(context).maybePop(true);
              } else if (state is MessageUpdateGroupSuccess) {
                setState(() {
                  _updatedGroupName = state.groupName;
                  _updatedGroupAvatar = state.groupAvatar;
                });
              }
            },
            builder: (context, state) {
              if (state is MessageUpdateGroupSuccess) {
                final currentUser = state.currentUser;
                return Column(
                  children: [
                    Expanded(
                      child: _listMessage(
                        state.listMessage,
                        currentUser,
                        widget.friend,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _sendMessage(currentUser, chatModel),
                  ],
                );
              }
              else if (state is MessageLoaded) {
                final currentUser = state.currentUser;
                return Column(
                  children: [
                    Expanded(
                      child: _listMessage(
                        state.listMessage,
                        currentUser,
                        widget.friend,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _sendMessage(currentUser, chatModel),
                  ],
                );
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }

  Widget _listMessage(
    List<MessageModel> listMessage,
    UserModel currentUser,
    UserModel? friend,
  ) {
    return ListView.separated(
      reverse: true,
      itemCount: listMessage.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (ctx, index) {
        final message = listMessage[index];
        final isMe = message.userIdSend == currentUser.uid;
        if (isMe) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const SizedBox(width: 38),
              Flexible(
                child: message.type == 'text'
                    ? Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isMe ? context.theme.primaryColor : context.theme.grey300Color,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          message.text,
                          style: TextStyleUtils.normal(
                            fontSize: 16,
                            color: isMe ? context.theme.backgroundColor : context.theme.textColor,
                            context: context,
                          ),
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          message.text,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
              const SizedBox(width: 8),
              BaseAvatar(
                url: currentUser.avatar,
                randomText: currentUser.uid,
                size: 30,
              ),
            ],
          );
        } else {
          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              friend != null
                  ? BaseAvatar(
                      url: friend.avatar,
                      randomText: friend.uid,
                      size: 30,
                    )
                  : BaseAvatar(
                      url: listMessage[index].userAvatarSend,
                      randomText: listMessage[index].userIdSend,
                      size: 30,
                    ),
              const SizedBox(width: 8),
              Flexible(
                child: message.type == 'text'
                    ? Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isMe ? context.theme.primaryColor : context.theme.grey300Color,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          message.text,
                          style: TextStyleUtils.normal(
                            fontSize: 16,
                            color: isMe ? context.theme.backgroundColor : context.theme.textColor,
                            context: context,
                          ),
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          message.text,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
              const SizedBox(width: 38),
            ],
          );
        }
      },
    );
  }

  Widget _sendMessage(UserModel currentUser, ChatModel chatModel) {
    return Builder(builder: (context) {
      return Row(
        children: [
          InkWell(
            onTap: () async {
              final imageFile = await _takeImage();
              if (imageFile == null) return;
              context.read<MessageCubit>().sendMessage(
                    userIdSend: currentUser.uid,
                    userAvatarSend: currentUser.avatar,
                    userNameSend: currentUser.lastName,
                    text: '',
                    createdAt: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
                    seenBy: chatModel.members,
                    chatId: chatModel.id,
                    type: 'image',
                    imageFile: imageFile,
                  );
            },
            child: Icon(
              FontAwesomeIcons.camera,
              color: context.theme.textColor,
            ),
          ),
          const SizedBox(width: 16),
          InkWell(
            onTap: () async {
              final imageFile = await _pickImage();
              if (imageFile == null) return;
              context.read<MessageCubit>().sendMessage(
                    userIdSend: currentUser.uid,
                    userAvatarSend: currentUser.avatar,
                    userNameSend: currentUser.lastName,
                    text: '',
                    createdAt: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
                    seenBy: chatModel.members,
                    chatId: chatModel.id,
                    type: 'image',
                    imageFile: imageFile,
                  );
            },
            child: Icon(
              FontAwesomeIcons.image,
              color: context.theme.textColor,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: BaseTextField(
              controller: _messageController,
              hintText: context.language.typeMessage,
              suffixIcon: InkWell(
                onTap: () {
                  if (_messageController.text.trim().isEmpty) return;
                  context.read<MessageCubit>().sendMessage(
                        userIdSend: currentUser.uid,
                        userAvatarSend: currentUser.avatar,
                        userNameSend: currentUser.lastName,
                        text: _messageController.text,
                        createdAt: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
                        seenBy: chatModel.members,
                        chatId: chatModel.id,
                        type: 'text',
                      );
                  _messageController.clear();
                },
                child: Icon(
                  FontAwesomeIcons.paperPlane,
                  color: context.theme.textColor,
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}
