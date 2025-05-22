import 'dart:io';

import 'package:app_chat/core/ext_context/ext_context.dart';
import 'package:app_chat/core/utils/dialog_utils.dart';
import 'package:app_chat/screen/profile_screen/cubit/update_profile_cubit.dart';
import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/utils/text_style_utils.dart';
import '../../core/widget/base_text_field.dart';
import '../../data/model/user_model.dart';
import '../auth/cubit/auth_cubit.dart';

@RoutePage()
class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key, required this.user});

  final UserModel user;

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _usernameController = TextEditingController();
  File? _imageFile;

  @override
  void initState() {
    _firstNameController.text = widget.user.firstName;
    _lastNameController.text = widget.user.lastName;
    _usernameController.text = widget.user.username;
    super.initState();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _imageFile = File(pickedFile.path));
    }
  }

  Future<void> _takePhoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() => _imageFile = File(pickedFile.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UpdateProfileCubit(),
      child: BlocConsumer<UpdateProfileCubit, UpdateProfileState>(
        listener: (context, state) {
          if (state is UpdateProfileLoading) {
            DialogUtils.showLoadingDialog(context);
          }
          if (state is UpdateProfileSuccess) {
            DialogUtils.hideLoadingDialog(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(context.language.updateProfileSuccessContent),
                backgroundColor: context.theme.greenColor,
              ),
            );
            context.read<AuthCubit>().updateCurrentUser(state.user);
          }
          if (state is UpdateProfileError) {
            DialogUtils.hideLoadingDialog(context);
            DialogUtils.showErrorDialog(
              context: context,
              message: state.message,
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                context.language.updateProfile,
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
              centerTitle: true,
              backgroundColor: context.theme.primaryColor,
              elevation: 0,
              actions: [
                IconButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      DialogUtils.showConfirmDialog(
                        context: context,
                        content: context.language.updateProfileContent,
                        confirmButton: context.language.change,
                        onConfirm: () {
                          context.read<UpdateProfileCubit>().updateProfile(
                                user: widget.user,
                                username: _usernameController.text,
                                firstName: _firstNameController.text,
                                lastName: _lastNameController.text,
                                imageFile: _imageFile,
                              );
                        },
                      );
                    }
                  },
                  icon: Icon(
                    FontAwesomeIcons.floppyDisk,
                    size: 18,
                    color: context.theme.backgroundColor,
                  ),
                ),
              ],
            ),
            body: Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: context.theme.backgroundColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      GestureDetector(
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
                            await _pickImage();
                          } else if (result == 'camera') {
                            await _takePhoto();
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
                                : widget.user.avatar.isNotEmpty
                                    ? DecorationImage(
                                        image: NetworkImage(widget.user.avatar),
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
                      const SizedBox(height: 24),
                      BaseTextField(
                        controller: _usernameController,
                        labelText: context.language.username,
                        prefixIcon: Icon(
                          FontAwesomeIcons.at,
                          color: context.theme.textColor,
                          size: 16,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return context.language.usernameRequired;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      BaseTextField(
                        controller: _firstNameController,
                        labelText: context.language.firstName,
                        prefixIcon: Icon(
                          FontAwesomeIcons.user,
                          color: context.theme.textColor,
                          size: 16,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return context.language.firstNameRequired;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      BaseTextField(
                        controller: _lastNameController,
                        labelText: context.language.lastName,
                        prefixIcon: Icon(
                          FontAwesomeIcons.user,
                          color: context.theme.textColor,
                          size: 16,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return context.language.lastNameRequired;
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
