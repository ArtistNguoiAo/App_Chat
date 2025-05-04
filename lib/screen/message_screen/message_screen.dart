import 'package:app_chat/data/model/user_model.dart';
import 'package:app_chat/screen/message_screen/cubit/message_cubit.dart';
import 'package:auto_route/annotations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repository/message_repository.dart';

@RoutePage()
class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key, required this.user});

  final UserModel user;

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {

  final _controller = TextEditingController();
  String _message = '';

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser!;
    return BlocProvider(
      create: (context) => MessageCubit()..loadMessage(
        userIdFrom: currentUser.uid,
        userIdTo: widget.user.uid,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Chat with ${widget.user.fullName}'),
        ),
        body: Column(
          children: [
            Expanded(
              child: BlocBuilder<MessageCubit, MessageState>(
                builder: (context, state) {
                  if (state is MessageLoaded) {
                    final messages = state.listMessage;
                    return ListView.builder(
                      reverse: true,
                      itemCount: messages.length,
                      itemBuilder: (ctx, index) {
                        final message = messages[index];
                        final isMe = message.userIdFrom == currentUser.uid;
                        return ListTile(
                          title: Align(
                            alignment:
                            isMe ? Alignment.centerRight : Alignment.centerLeft,
                            child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: isMe ? Colors.blue : Colors.grey[300],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                message.text,
                                style: TextStyle(color: isMe ? Colors.white : Colors.black),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                  return Container();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(labelText: 'Send a message...'),
                      onChanged: (val) {
                        setState(() {
                          _message = val;
                        });
                      },
                    ),
                  ),
                  Builder(
                    builder: (context) {
                      return IconButton(
                        icon: Icon(Icons.send),
                        onPressed: () {
                          if (_message.trim().isEmpty) return;
                          context.read<MessageCubit>().sendMessage(
                            userIdFrom: currentUser.uid,
                            userIdTo: widget.user.uid,
                            text: _message,
                          );
                          _controller.clear();
                          setState(() {
                            _message = '';
                          });
                        },
                      );
                    }
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
