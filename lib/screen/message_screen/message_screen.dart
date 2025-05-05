import 'package:app_chat/core/ext_context/ext_context.dart';
import 'package:app_chat/core/utils/text_style_utils.dart';
import 'package:app_chat/core/widget/base_text_field.dart';
import 'package:app_chat/data/model/message_model.dart';
import 'package:app_chat/data/model/user_model.dart';
import 'package:app_chat/screen/message_screen/cubit/message_cubit.dart';
import 'package:auto_route/annotations.dart';
import 'package:avatar_plus/avatar_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repository/message_repository.dart';

@RoutePage()
class MessageScreen extends StatefulWidget {
  const MessageScreen({
    super.key,
    required this.user,
    required this.currentUser,
  });

  final UserModel user;
  final UserModel currentUser;

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MessageCubit()
        ..loadMessage(
          userIdFrom: widget.currentUser.uid,
          userIdTo: widget.user.uid,
        ),
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top,
            left: 16,
            right: 16,
            bottom: 16,
          ),
          child: BlocConsumer<MessageCubit, MessageState>(
            listener: (context, state) {
              // TODO: implement listener
            },
            builder: (context, state) {
              if (state is MessageLoaded) {
                return Column(
                  children: [
                    widget.currentUser.avatar.isNotEmpty
                        ? Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: context.theme.borderColor,
                            ),
                            child: ClipOval(
                              child: Image.network(
                                widget.currentUser.avatar,
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        : AvatarPlus(
                            widget.currentUser.uid,
                            height: 60,
                            width: 60,
                          ),
                    Expanded(
                      child: _listMessage(
                        state.listMessage,
                      ),
                    ),
                    _sendMessage(),
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
  ) {
    return ListView.separated(
      reverse: true,
      itemCount: listMessage.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (ctx, index) {
        final message = listMessage[index];
        final isMe = message.userIdSend == widget.currentUser.uid;
        if (isMe) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const SizedBox(width: 38),
              Flexible(
                child: Container(
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
                ),
              ),
              const SizedBox(width: 8),
              widget.currentUser.avatar.isNotEmpty
                  ? Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: context.theme.borderColor,
                ),
                child: ClipOval(
                  child: Image.network(
                    widget.currentUser.avatar,
                    fit: BoxFit.cover,
                  ),
                ),
              )
                  : AvatarPlus(
                widget.currentUser.uid,
                height: 30,
                width: 30,
              ),
            ],
          );
        } else {
          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              widget.currentUser.avatar.isNotEmpty
                  ? Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: context.theme.borderColor,
                ),
                child: ClipOval(
                  child: Image.network(
                    widget.user.avatar,
                    fit: BoxFit.cover,
                  ),
                ),
              )
                  : AvatarPlus(
                widget.user.uid,
                height: 30,
                width: 30,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Container(
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
                ),
              ),
              const SizedBox(width: 38),
            ],
          );
        }
      },
    );
  }

  Widget _sendMessage() {
    return Row(
      children: [
        Expanded(
          child: BaseTextField(
            controller: _messageController,
            hintText: context.language.typeMessage,
            suffixIcon: InkWell(
              onTap: () {
                // if (_messageController.text.trim().isEmpty) return;
                //
                // _messageController.clear();
              },
              child: Icon(
                Icons.send,
                color: context.theme.textColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
