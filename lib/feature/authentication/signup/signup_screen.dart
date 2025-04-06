
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:greener/core/widgets/custom_text_snack_bar.dart';
import 'package:greener/core/widgets/loading_indicator.dart';
import 'package:greener/feature/authentication/signup/cubit/signup_cubit.dart';
import 'package:greener/feature/authentication/widgets/authentication_header.dart';
import 'package:greener/feature/home/main_screen.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/constants/kcolors.dart';
import '../../../core/widgets/custom_text.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/profile_image.dart';
import '../login/login_screen.dart';
import '../model/user_model.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignupCubit(),
      child:  const SignupScreenContent(),
    );
  }
}

class SignupScreenContent extends StatelessWidget {
    const SignupScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    XFile? image;
    final TextEditingController nameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passController = TextEditingController();
    final TextEditingController passCheckController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final FocusNode emailFocusNode = FocusNode();
    final FocusNode passFocusNode = FocusNode();
    final FocusNode checkPassFocusNode = FocusNode();
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0.w),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                const AuthenticationHeader(
                  title: "Create new account",
                  subTitle: "Set up your email and password",
                ),
                ProfileImage(onImageChanged: (data) {
                  image = data;
                }),
                Padding(
                  padding: EdgeInsets.only(top: 10.0.h),
                  child: CustomTextField(
                    text: "Name",
                    validator: (inputText) {
                      return inputText!.length < 4
                          ? "Enter a valid name"
                          : null;
                    },
                    onSubmit: (input) {
                      FocusScope.of(context).requestFocus(emailFocusNode);
                    },
                    controller: nameController,
                    inputType: TextInputType.name,
                  ),
                ),
                CustomTextField(
                  currentFocusNode: emailFocusNode,
                  text: "Email",
                  controller: emailController,
                  onSubmit: (input) {
                    FocusScope.of(context).requestFocus(passFocusNode);
                  },
                  validator: (inputText) {
                    return inputText!.isEmail ? null : "Enter a valid email";
                  },
                  inputType: TextInputType.emailAddress,
                ),
                CustomTextField(
                  currentFocusNode: passFocusNode,
                  text: "Password",
                  controller: passController,
                  isPassword: true,
                  onSubmit: (input) {
                    FocusScope.of(context).requestFocus(checkPassFocusNode);
                  },
                  validator: (inputText) {
                    if (inputText!.length < 5) {
                      return "Password must be at least 5 characters";
                    }
                    return null;
                  },
                  inputType: TextInputType.visiblePassword,
                ),
                CustomTextField(
                  currentFocusNode: checkPassFocusNode,
                  text: "Confirm password",
                  validator: (inputText) {
                    return inputText != passController.text
                        ? "Passwords do not match"
                        : null;
                  },
                  controller: passCheckController,
                  isPassword: true,
                  bottomPadding: 20,
                  onSubmit: (input) {
                    if (formKey.currentState?.validate() ?? false) {
                      context.read<SignupCubit>().signupWithEmailAndPassword(
                            password: passController.text,
                            user: UserModel(
                              name: nameController.text,
                              email: emailController.text,
                            ),
                        image: image==null?null:File(image!.path),
                      );
                    }
                  },
                  inputType: TextInputType.visiblePassword,
                ),
                BlocConsumer<SignupCubit, SignupState>(
                  listener: (context, state) {
                    if (state is SignupErrorState) {
                      CustomTextSnackBar(message: state.message);
                    }
                    if (state is SignupSuccessState) {
                      Get.offAll(() => const MainScreen());
                      nameController.dispose();
                      emailController.dispose();
                      passController.dispose();
                      passCheckController.dispose();
                    }
                  },
                  builder: (context, state) {
                    if (state is SignupLoadingState) {
                      return const LoadingIndicator();
                    }
                    return InkWell(
                      child: Container(
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          color: baseColor,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Center(
                          child: CustomText(
                            text: "Sign up",
                            textColor: Colors.white,
                            textWeight: FontWeight.w400,
                            textSize: 18,
                          ),
                        ),
                      ),
                      onTap: () {
                        if (formKey.currentState?.validate() ?? false) {
                          context
                              .read<SignupCubit>()
                              .signupWithEmailAndPassword(
                                password: passController.text,
                                user: UserModel(
                                  name: nameController.text,
                                  email: emailController.text,
                                ),
                                image: image==null?null:File(image!.path),
                              );
                        }
                      },
                    );
                  },
                ),
                SizedBox(
                  height: 25.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CustomText(
                      text: "Already have an account? ",
                      textSize: 14,
                      textWeight: FontWeight.w400,
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.offAll(() => const LoginScreen());
                      },
                      child: const CustomText(
                        text: "Login",
                        textSize: 14,
                        textWeight: FontWeight.w400,
                        textColor: baseColor,
                      ),
                    )
                  ],
                ),
                SizedBox(height: 35.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
