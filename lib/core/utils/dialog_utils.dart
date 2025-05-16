import 'package:app_chat/core/ext_context/ext_context.dart';
import 'package:app_chat/core/utils/text_style_utils.dart';
import 'package:app_chat/core/widget/base_text_field.dart';
import 'package:app_chat/data/model/user_model.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DialogUtils {
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
                          if(searchController.text.isEmpty) {
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
                      border: Border.all(color: context.theme.borderColor),
                    ),
                    child: Text(
                      context.language.cancel,
                      style: TextStyleUtils.normal(
                        context: context,
                        fontSize: 16,
                        color: context.theme.borderColor,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    if (selectedUserIds.length < 2) {
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
}
