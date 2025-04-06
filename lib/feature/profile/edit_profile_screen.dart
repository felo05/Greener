import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:greener/core/constants/kcolors.dart';
import 'package:greener/core/widgets/custom_text_snack_bar.dart';
import 'package:greener/core/widgets/loading_indicator.dart';
import 'package:greener/core/widgets/profile_image.dart';
import 'package:greener/feature/profile/cubit/edit_profile_cubit.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/helpers/hive_helper.dart';
import '../../core/widgets/back_appbar.dart';
import '../../core/widgets/custom_text.dart';
import '../../core/widgets/custom_text_alert_dialog.dart';
import '../../core/widgets/custom_text_field.dart';
import '../authentication/model/user_model.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({super.key, required this.user});

  final UserModel user;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    _nameController.text = user.name ?? '';
    XFile? image;
    return Scaffold(
      appBar: BackAppBar(
        title: 'Edit Profile',
        backgroundColor: baseColor,
        textColor: Colors.white,
        onPressBack: () {
          if (user.name != _nameController.text) {
            CustomTextAlertDialog(
              title: 'Discard Changes',
              content: 'Are you sure you want to discard changes?',
              buttonText: 'Discard',
              onPressed: () {
                _nameController.dispose();
                Get.back();
                Get.back();
              },
            );
          } else {
            _nameController.dispose();
            Get.back();
          }
        },
      ),
      body: Form(
          key: _formKey,
          child: Column(
            children: [
              ProfileImage(onImageChanged: (data) {
                image = data;
              }),
              SizedBox(height: 10.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: CustomTextField(
                  controller: _nameController,
                  text: 'Name',
                  inputType: TextInputType.text,
                  floatingLabel: true,
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 3) {
                      return 'Please enter a valid name';
                    } else if (value == user.name && image == null) {
                      return 'Please enter a new name';
                    }
                    return null;
                  },
                ),
              ),
              const Spacer(),
              BlocProvider(
                create: (context) => EditProfileCubit(),
                child: BlocConsumer<EditProfileCubit, EditProfileState>(
                  listener: (context, state) {
                    if (state is EditProfileSuccess) {
                      user.name = state.newName;
                      user.image = state.newImage ?? user.image;
                      Get.back();
                    }
                    if (state is EditProfileError) {
                      print(state.errorMessage);
                      CustomTextSnackBar(
                        message: state.errorMessage
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is EditProfileLoading) {
                      return const Center(
                        child: LoadingIndicator(),
                      );
                    }
                    return InkWell(
                      child: Container(
                        margin: EdgeInsets.all(12.0.r),
                        width: double.infinity,
                        height: 56.h,
                        decoration: BoxDecoration(
                          color: baseColor,
                          borderRadius: BorderRadius.circular(15.r),
                        ),
                        child: const Center(
                          child: CustomText(
                            text: "Save Changes",
                            textColor: Colors.white,
                            textWeight: FontWeight.w500,
                            textSize: 20,
                          ),
                        ),
                      ),
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<EditProfileCubit>().editProfile(
                              HiveHelper.getId()!,
                              _nameController.text,
                              image == null ? null : File(image!.path));
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          )),
    );
  }
}
