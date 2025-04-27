// lib/screen/profile_screen/update_profile_screen.dart
import 'dart:io';

import 'package:app_chat/core/ext_context/ext_context.dart';
import 'package:app_chat/screen/profile_screen/cubit/update_profile_cubit.dart';
import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/widget/base_text_field.dart';
import '../../data/model/user_model.dart';
import '../auth/cubit/auth_cubit.dart';

@RoutePage()
class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _usernameController = TextEditingController();
  File? _imageFile;
  late final UserModel _user;

  @override
  void initState() {
    super.initState();
    _user = context.read<AuthCubit>().getCurrentUser()!;
    _firstNameController.text = _user.firstName;
    _lastNameController.text = _user.lastName;
    _usernameController.text = _user.username;
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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UpdateProfileCubit(),
      child: BlocConsumer<UpdateProfileCubit, UpdateProfileState>(
        listener: (context, state) {
          if (state is UpdateProfileSuccess) {
            context.read<AuthCubit>().updateCurrentUser(state.user);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(context.language.profileUpdateSuccess)),
            );
            Navigator.pop(context);
          } else if (state is UpdateProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(context.language.updateProfile),
              actions: [
                if (state is! UpdateProfileLoading)
                  IconButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        context.read<UpdateProfileCubit>().updateProfile(
                              user: _user,
                              username: _usernameController.text,
                              firstName: _firstNameController.text,
                              lastName: _lastNameController.text,
                              imageFile: _imageFile,
                            );
                      }
                    },
                    icon: const Icon(Icons.save),
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
                        onTap: _pickImage,
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
                                : DecorationImage(
                                    image: NetworkImage(_user.avatar),
                                    fit: BoxFit.cover,
                                  ),
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
                      if (state is UpdateProfileLoading)
                        const Padding(
                          padding: EdgeInsets.only(top: 16),
                          child: CircularProgressIndicator(),
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
