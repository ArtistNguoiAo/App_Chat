import 'dart:io';

import 'package:app_chat/core/ext_context/ext_context.dart';
import 'package:app_chat/core/utils/dialog_utils.dart';
import 'package:app_chat/core/utils/text_style_utils.dart';
import 'package:app_chat/core/widget/base_avatar.dart';
import 'package:app_chat/core/widget/base_text_field.dart';
import 'package:app_chat/data/model/chat_model.dart';
import 'package:app_chat/data/model/message_model.dart';
import 'package:app_chat/data/model/user_model.dart';
import 'package:app_chat/screen/message_screen/cubit/message_cubit.dart';
import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:avatar_plus/avatar_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

@RoutePage()
class MessageScreen extends StatefulWidget {
  MessageScreen({
    super.key,
    required this.chatModel,
    this.friend,
  });

  final ChatModel chatModel;
  UserModel? friend;

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MessageCubit()
        ..loadMessage(
          seenBy: widget.chatModel.members,
          chatId: widget.chatModel.id,
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
                      url: widget.chatModel.groupAvatar,
                      randomText: widget.chatModel.id,
                      size: 40,
                    ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.friend != null ? widget.friend!.fullName : widget.chatModel.groupName,
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
            ],
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
            Builder(
              builder: (context) {
                return InkWell(
                  onTap: () {
                    DialogUtils.showUserInfoDialog(
                      context: context,
                      user: widget.friend!,
                      isFriend: true,
                      onDeleteFriend: () {
                        context.read<MessageCubit>().deleteFriend(
                          userModel: widget.friend!,
                          chatId: widget.chatModel.id,
                        );
                      },
                    );
                  },
                  child: Icon(
                    FontAwesomeIcons.circleInfo,
                    color: context.theme.backgroundColor,
                    size: 18,
                  ),
                );
              }
            ),
            const SizedBox(width: 16),
          ],
          backgroundColor: context.theme.primaryColor,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: BlocConsumer<MessageCubit, MessageState>(
            listener: (context, state) {
              if (state is MessageDeleteSuccess) {
                AutoRouter.of(context).maybePop();
              }
            },
            builder: (context, state) {
              if (state is MessageLoaded) {
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
                    _sendMessage(currentUser),
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
              currentUser.avatar.isNotEmpty
                  ? Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: context.theme.borderColor,
                      ),
                      child: ClipOval(
                        child: Image.network(
                          currentUser.avatar,
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  : AvatarPlus(
                      currentUser.uid,
                      height: 30,
                      width: 30,
                    ),
            ],
          );
        } else {
          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              currentUser.avatar.isNotEmpty
                  ? Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: context.theme.borderColor,
                      ),
                      child: ClipOval(
                        child: Image.network(
                          friend?.avatar ?? '',
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  : AvatarPlus(
                      friend?.uid ?? '',
                      height: 30,
                      width: 30,
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

  Widget _sendMessage(UserModel currentUser) {
    return Builder(builder: (context) {
      return Row(
        children: [
          InkWell(
            onTap: () async {
              final imageFile = await _takeImage();
              if (imageFile == null) return;
              context.read<MessageCubit>().sendMessage(
                userIdSend: currentUser.uid,
                text: '',
                createdAt: DateFormat('dd-MM-yyyy HH:mm:ss').format(DateTime.now()),
                seenBy: widget.chatModel.members,
                chatId: widget.chatModel.id,
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
                text: '',
                createdAt: DateFormat('dd-MM-yyyy HH:mm:ss').format(DateTime.now()),
                seenBy: widget.chatModel.members,
                chatId: widget.chatModel.id,
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
                        text: _messageController.text,
                        createdAt: DateFormat('dd-MM-yyyy HH:mm:ss').format(DateTime.now()),
                        seenBy: widget.chatModel.members,
                        chatId: widget.chatModel.id,
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
