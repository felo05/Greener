import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:greener/core/constants/kcolors.dart';
import 'package:greener/core/widgets/custom_text_snack_bar.dart';
import 'package:greener/core/widgets/loading_indicator.dart';
import 'package:greener/feature/authentication/repository/authentication_repository_implementation.dart';
import 'package:greener/feature/authentication/signup/signup_screen.dart';
import 'package:greener/feature/home/main_screen.dart';

import '../../../core/widgets/custom_text.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../reset_password/reset_password_screen.dart';
import '../widgets/authentication_header.dart';
import 'cubit/login_cubit.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final FocusNode passFocusNode = FocusNode();
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: whitenColor,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Column(
            children: [
              Expanded(
                flex: 4,
                child: Column(
                  children: [
                    const Expanded(
                      flex: 6,
                      child: AuthenticationHeader(
                        title: "Welcome back",
                        subTitle: "Log in to your account",
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Form(
                        key: formKey,
                        child: Column(
                          children: [
                            CustomTextField(
                              text: "Email",
                              inputType: TextInputType.emailAddress,
                              controller: emailController,
                              validator: (inputText) {
                                if (!(inputText!.isEmail ||
                                    inputText.isPhoneNumber)) {
                                  return "Invalid email or phone";
                                }
                                return null;
                              },
                              onSubmit: (input) {
                                FocusScope.of(context)
                                    .requestFocus(passFocusNode);
                              },
                            ),
                            const SizedBox(height: 20),
                            BlocProvider(
                              create: (context) => LoginCubit(),
                              child: CustomTextField(
                                currentFocusNode: passFocusNode,
                                text: "Password",
                                controller: passController,
                                isPassword: true,
                                bottomPadding: 0,
                                onSubmit: (input) {
                                  if (formKey.currentState?.validate() ??
                                      false) {
                                    context
                                        .read<LoginCubit>()
                                        .loginWithEmailAndPassword(
                                            email: emailController.text,
                                            password: input);
                                  }
                                },
                                inputType: TextInputType.visiblePassword,
                                validator: (inputText) {
                                  if (inputText!.length < 5) {
                                    return "Password must be at least 5 characters";
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Row(
                              children: [
                                const Spacer(),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: GestureDetector(
                                    onTap: () {
                                      Get.to(() => const ResetPasswordScreen());
                                    },
                                    child: const CustomText(
                                      text: "Forgot password?",
                                      textColor: baseColor,
                                      textWeight: FontWeight.w300,
                                      textSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    BlocProvider(
                      create: (context) => LoginCubit(),
                      child: BlocConsumer<LoginCubit, LoginState>(
                        listener: (context, state) {
                          if (state is LoginErrorState) {
                            CustomTextSnackBar(message: state.message);
                          }
                          if (state is LoginSuccessState) {
                            Get.offAll(() => const MainScreen());
                            emailController.dispose();
                            passController.dispose();
                          }
                        },
                        builder: (context, state) {
                          if (state is LoginLoadingState) {
                            return const LoadingIndicator();
                          }

                          return InkWell(
                            child: Container(
                              width: double.infinity,
                              height: 56.h,
                              decoration: BoxDecoration(
                                color: baseColor,
                                borderRadius: BorderRadius.circular(15.r),
                              ),
                              child: const Center(
                                child: CustomText(
                                  text: "Login",
                                  textColor: Colors.white,
                                  textWeight: FontWeight.w400,
                                  textSize: 18,
                                ),
                              ),
                            ),
                            onTap: () {
                              if (formKey.currentState?.validate() ?? false) {
                                context
                                    .read<LoginCubit>()
                                    .loginWithEmailAndPassword(
                                        email: emailController.text,
                                        password: passController.text);
                              }
                            },
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 40.h),
                    Center(
                      child: InkWell(
                        onTap: () async {
                          (await AuthenticationRepositoryImplementation()
                                  .authenticateWithGoogle())
                              .fold((name) {
                            CustomTextSnackBar(
                                message:
                                    "You have logged in successfully${name.isEmpty ? null : " as $name"}");
                            Get.offAll(() => const MainScreen());
                          }, (fail) {
                            CustomTextSnackBar(
                              message: fail.errorMessage,
                            );
                          });
                        },
                        child: Image.asset("assets/images/google.png",
                            height: 50.h, width: 50.w),
                      ),
                    ),
                    SizedBox(height: 30.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CustomText(
                          text: "Don't have an account? ",
                          textSize: 14,
                          textWeight: FontWeight.w400,
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.offAll(() => const SignupScreen());
                          },
                          child: const CustomText(
                            text: "Sign up",
                            textSize: 14,
                            textWeight: FontWeight.w400,
                            textColor: baseColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 35.h),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
