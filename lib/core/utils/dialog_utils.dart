import 'dart:io';

import 'package:app_chat/core/ext_context/ext_context.dart';
import 'package:app_chat/core/utils/text_style_utils.dart';
import 'package:app_chat/core/widget/base_loading.dart';
import 'package:app_chat/core/widget/base_text_field.dart';
import 'package:app_chat/data/model/chat_model.dart';
import 'package:app_chat/data/model/user_model.dart';
import 'package:auto_route/auto_route.dart';
import 'package:avatar_plus/avatar_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class DialogUtils {
  static bool _isShowing = false;

  static void showLoadingDialog(BuildContext context) {
    if (_isShowing) return;
    _isShowing = true;
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            elevation: 8.0,
            contentPadding: const EdgeInsets.all(16.0),
            content: SizedBox(
              width: 150.0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  LoadingAnimationWidget.staggeredDotsWave(
                    color: context.theme.primaryColor,
                    size: 40,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${context.language.loading}...',
                    style: TextStyleUtils.bold(
                      fontSize: 16,
                      color: context.theme.textColor,
                      context: context,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  static void hideLoadingDialog(BuildContext context) {
    if (_isShowing) {
      Navigator.of(context).pop();
      _isShowing = false;
    }
  }

  static void showErrorDialog({required BuildContext context, required String message}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                FontAwesomeIcons.triangleExclamation,
                size: 22,
                color: context.theme.redColor,
              ),
              const SizedBox(height: 10),
              Text(
                message,
                style: TextStyleUtils.normal(
                  fontSize: 16,
                  color: context.theme.textColor,
                  context: context,
                ),
              ),
            ],
          ),
          actions: [
            InkWell(
              onTap: () {
                AutoRouter.of(context).maybePop();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: context.theme.primaryColor),
                  color: context.theme.primaryColor,
                ),
                child: Text(
                  'OK',
                  style: TextStyleUtils.normal(
                    context: context,
                    fontSize: 16,
                    color: context.theme.backgroundColor,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  static void showConfirmDialog({
    required BuildContext context,
    required String content,
    required String confirmButton,
    required Function onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                content,
                style: TextStyleUtils.normal(
                  fontSize: 18,
                  color: context.theme.textColor,
                  context: context,
                ),
              ),
            ],
          ),
          actions: [
            InkWell(
              onTap: () {
                AutoRouter.of(context).maybePop();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: context.theme.primaryColor),
                  color: context.theme.backgroundColor,
                ),
                child: Text(
                  context.language.cancel,
                  style: TextStyleUtils.normal(
                    context: context,
                    fontSize: 16,
                    color: context.theme.primaryColor,
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                AutoRouter.of(context).maybePop(true);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: context.theme.primaryColor),
                  color: context.theme.primaryColor,
                ),
                child: Text(
                  confirmButton,
                  style: TextStyleUtils.normal(
                    context: context,
                    fontSize: 16,
                    color: context.theme.backgroundColor,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    ).then((value) {
      if (value != null && value is bool && value) {
        onConfirm();
      }
    });
  }

  static Future<void> showListFriendDialog({
    required BuildContext context,
    required List<UserModel> listFriend,
    required Function(List<UserModel>, String) onSelected,
  }) {
    Set<String> selectedUserIds = {};
    TextEditingController searchController = TextEditingController();
    TextEditingController groupNameController = TextEditingController();
    List<UserModel> filteredList = listFriend;
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    BaseTextField(
                      controller: groupNameController,
                      fillColor: context.theme.backgroundColor,
                      labelText: context.language.groupName,
                      hintText: context.language.groupName,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      context.language.chooseFriend,
                      style: TextStyleUtils.bold(
                        fontSize: 20,
                        color: context.theme.textColor,
                        context: context,
                      ),
                    ),
                    const SizedBox(height: 10),
                    BaseTextField(
                      controller: searchController,
                      fillColor: context.theme.backgroundColor,
                      prefixIcon: const Icon(Icons.search),
                      hintText: context.language.search,
                      onChanged: (value) {
                        setState(() {
                          if (searchController.text.isEmpty) {
                            filteredList = listFriend;
                          } else {
                            filteredList = listFriend.where((user) {
                              return user.fullName.toLowerCase().contains(searchController.text.toLowerCase());
                            }).toList();
                          }
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 250,
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        color: context.theme.backgroundColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListView.builder(
                        itemCount: filteredList.length,
                        itemBuilder: (context, index) {
                          final user = filteredList[index];
                          final isSelected = selectedUserIds.contains(user.uid);
                          return CheckboxListTile(
                            title: Text(user.fullName),
                            value: isSelected,
                            activeColor: context.theme.primaryColor,
                            onChanged: (bool? value) {
                              setState(() {
                                if (value == true) {
                                  selectedUserIds.add(user.uid);
                                } else {
                                  selectedUserIds.remove(user.uid);
                                }
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                InkWell(
                  onTap: () {
                    AutoRouter.of(context).maybePop();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: context.theme.primaryColor),
                      color: context.theme.backgroundColor,
                    ),
                    child: Text(
                      context.language.cancel,
                      style: TextStyleUtils.normal(
                        context: context,
                        fontSize: 16,
                        color: context.theme.primaryColor,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    if (groupNameController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(context.language.pleaseEnterGroupName),
                        ),
                      );
                    } else if (selectedUserIds.length < 2) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(context.language.pleaseChooseMin2Friends),
                        ),
                      );
                    } else {
                      final selectedFriends = listFriend.where((user) => selectedUserIds.contains(user.uid)).toList();
                      Navigator.of(context).pop(selectedFriends);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: context.theme.primaryColor,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: context.theme.primaryColor),
                    ),
                    child: Text(
                      context.language.create,
                      style: TextStyleUtils.normal(
                        context: context,
                        fontSize: 16,
                        color: context.theme.backgroundColor,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    ).then((value) {
      if (value != null && value is List<UserModel>) {
        onSelected(value, groupNameController.text);
      }
    });
  }

  static Future<void> showUserInfoDialog({
    required BuildContext context,
    required UserModel user,
    required bool isFriend,
    required Function onDeleteFriend,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.theme.backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(child: Container()),
                    InkWell(
                      onTap: () {
                        AutoRouter.of(context).maybePop();
                      },
                      child: Icon(
                        FontAwesomeIcons.circleXmark,
                        size: 22,
                        color: context.theme.redColor,
                      ),
                    ),
                  ],
                ),
                if (user.avatar.isNotEmpty) ...[
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: context.theme.borderColor,
                    ),
                    child: ClipOval(
                      child: Image.network(
                        user.avatar,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                ] else ...[
                  AvatarPlus(
                    user.uid,
                    height: 60,
                    width: 60,
                  )
                ],
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: context.theme.textColor,
                    borderRadius: BorderRadius.circular(32),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 8,
                  ),
                  child: Text(
                    '@${user.username}',
                    style: TextStyleUtils.normal(
                      fontSize: 14,
                      color: context.theme.backgroundColor,
                      context: context,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  user.fullName,
                  style: TextStyleUtils.bold(
                    fontSize: 18,
                    color: context.theme.textColor,
                    context: context,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  user.email,
                  style: TextStyleUtils.normalItalic(
                    fontSize: 16,
                    color: context.theme.borderColor,
                    context: context,
                  ),
                ),
                const SizedBox(height: 8),
                if (isFriend) ...[
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          width: double.maxFinite,
                          padding: const EdgeInsets.symmetric(
                            vertical: 4,
                            horizontal: 8,
                          ),
                          decoration: BoxDecoration(
                            color: context.theme.blueColor,
                            border: Border.all(
                              color: context.theme.blueColor,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            context.language.friend,
                            style: TextStyleUtils.bold(
                              fontSize: 16,
                              color: context.theme.backgroundColor,
                              context: context,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      PopupMenuButton(
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: context.theme.backgroundColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            FontAwesomeIcons.ellipsisVertical,
                            size: 20,
                            color: context.theme.textColor,
                          ),
                        ),
                        onSelected: (value) {
                          if (value == 1) {
                            AutoRouter.of(context).maybePop(true);
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 1,
                            child: Text(
                              context.language.deleteFriend,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ]
              ],
            ),
          ),
        );
      },
    ).then((value) {
      if (value != null && value is bool && value) {
        onDeleteFriend();
      }
    });
  }

  static Future<void> showGroupInfoDialog({
    required BuildContext context,
    required ChatModel chat,
    required Function onFunction,
  }) {
    File? _imageFile;
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.theme.backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return SingleChildScrollView(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () async {
                      final result = await showDialog<String>(
                        context: context,
                        builder: (context) => AlertDialog(
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                leading: const Icon(FontAwesomeIcons.image),
                                title: Text(context.language.pickFromGallery),
                                onTap: () {
                                  Navigator.pop(context, 'gallery');
                                },
                              ),
                              ListTile(
                                leading: const Icon(FontAwesomeIcons.camera),
                                title: Text(context.language.takePhoto),
                                onTap: () {
                                  Navigator.pop(context, 'camera');
                                },
                              ),
                            ],
                          ),
                        ),
                      );

                      if (result == 'gallery') {
                        final picker = ImagePicker();
                        final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                        if (pickedFile != null) {
                          setState(() => _imageFile = File(pickedFile.path));
                        }
                      } else if (result == 'camera') {
                        final picker = ImagePicker();
                        final pickedFile = await picker.pickImage(source: ImageSource.camera);
                        if (pickedFile != null) {
                          setState(() => _imageFile = File(pickedFile.path));
                        }
                      }
                    },
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: context.theme.borderColor,
                        image: _imageFile != null
                            ? DecorationImage(
                          image: FileImage(_imageFile!),
                          fit: BoxFit.cover,
                        )
                            : chat.groupAvatar.isNotEmpty
                            ? DecorationImage(
                          image: NetworkImage(chat.groupAvatar),
                          fit: BoxFit.cover,
                        )
                            : null,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.camera_alt,
                          color: context.theme.backgroundColor,
                          size: 40,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    ).then((value) {
      if (value != null && value is bool && value) {}
    });
  }
}
