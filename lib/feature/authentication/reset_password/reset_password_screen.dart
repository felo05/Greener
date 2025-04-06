import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:greener/core/constants/kcolors.dart';
import 'package:greener/core/widgets/back_appbar.dart';
import 'package:greener/core/widgets/custom_text_field.dart';
import 'package:greener/core/widgets/custom_text_snack_bar.dart';
import 'package:greener/feature/authentication/reset_password/cubit/reset_password_cubit.dart';

import '../../../core/widgets/custom_text.dart';
import '../../../core/widgets/loading_indicator.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: const BackAppBar(
          title: "Reset Password",
          backgroundColor: baseColor,
          textColor: whitenColor),
      body: Center(
        child: BlocProvider(
          create: (context) => ResetPasswordCubit(),
          child: Column(
            children: [
              Form(
                key: formKey,
                child: CustomTextField(
                  text: "Email",
                  validator: (inputText) {
                    return inputText!.isEmail ? null : "Enter a valid email";
                  },
                  isPassword: false,
                  controller: emailController,
                  onSubmit: (input) {
                    if (formKey.currentState?.validate() ?? false) {
                      context
                          .read<ResetPasswordCubit>()
                          .resetPassword(emailController.text);
                    }
                  },
                  inputType: TextInputType.emailAddress,
                ),
              ),
              BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
                listener: (context, state) {
                  if (state is ResetPasswordSuccessState) {
                    Get.back();
                    emailController.dispose();
                    CustomTextSnackBar(message: "Check your email to reset password");
                  } else if (state is ResetPasswordErrorState) {
                    CustomTextSnackBar(message: state.message);
                  }
                },
                builder: (context, state) {
                  if (state is ResetPasswordLoadingState) {
                    return const Center(child: LoadingIndicator());
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
                            .read<ResetPasswordCubit>()
                            .resetPassword(emailController.text);
                      }
                    },
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
