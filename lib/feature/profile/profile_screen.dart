import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';
import 'package:greener/core/widgets/custom_network_image.dart';
import 'package:greener/feature/authentication/model/user_model.dart';
import 'package:greener/feature/profile/cubit/edit_profile_cubit.dart';

import '../../core/constants/kcolors.dart';
import '../../core/helpers/hive_helper.dart';
import '../../core/helpers/notification_helper.dart';
import '../../core/widgets/custom_text.dart';
import '../../core/widgets/custom_text_alert_dialog.dart';
import '../authentication/login/login_screen.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static UserModel user = HiveHelper.getUser() ?? UserModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: baseColor,
        centerTitle: true,
        title: const CustomText(
          text: "My Profile",
          textSize: 22,
          textColor: Colors.white,
          textWeight: FontWeight.bold,
        ),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 120.h,
            decoration: BoxDecoration(
                color: baseColor,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50.r),
                    bottomRight: Radius.circular(50.r))),
            child: Padding(
              padding: EdgeInsets.all(16.0.r),
              child: BlocProvider(
                create: (context) => EditProfileCubit(),
                child: BlocBuilder<EditProfileCubit, EditProfileState>(
                  builder: (context, state) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 40.r,
                          backgroundImage: user.image != null
                              ? CustomNetworkImage(image:user.image!)as ImageProvider
                              : null,
                          backgroundColor: Colors.grey[300],
                          child: user.image == null
                              ? Icon(Icons.person, size: 60.r, color: Colors.grey[600])
                              : null,
                        ),
                        SizedBox(width: 12.5.w),
                        SizedBox(
                          width: 235.w,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomText(
                                text: user.name!,
                                textSize: 20,
                                overflow: TextOverflow.ellipsis,
                                textWeight: FontWeight.bold,
                                textColor: Colors.white,
                              ),
                              CustomText(
                                text: user.email!,
                                overflow: TextOverflow.ellipsis,
                                textColor: Colors.white,
                                textSize: 18,
                                textWeight: FontWeight.w500,
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
          SizedBox(height: 5.h),
          InkWell(
            child: Container(
              margin: EdgeInsets.all(12.0.r),
              width: double.infinity,
              height: 56.h,
              decoration: BoxDecoration(
                color: baseColor,
                borderRadius: BorderRadius.circular(15.r),
              ),
              child: Center(
                child: Row(
                  spacing: 30.w,
                  children: [
                    SizedBox(width: 1.w),
                    Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 32.r,
                    ),
                    const CustomText(
                      text: "Edit Profile",
                      textColor: Colors.white,
                      textWeight: FontWeight.w600,
                      textSize: 24,
                    ),
                  ],
                ),
              ),
            ),
            onTap: () {
              Get.to(() => EditProfileScreen(
                    user: user,
                  ));
            },
          ),
          SizedBox(height: 15.h),
          const Spacer(),
          InkWell(
            child: Container(
              margin: EdgeInsets.all(12.0.r),
              width: double.infinity,
              height: 50.h,
              decoration: BoxDecoration(
                color: const Color(0xFFFD0000),
                borderRadius: BorderRadius.circular(15.r),
              ),
              child: const Center(
                child: CustomText(
                  text: "Logout",
                  textColor: Colors.white,
                  textWeight: FontWeight.w500,
                  textSize: 20,
                ),
              ),
            ),
            onTap: () {
              CustomTextAlertDialog(
                  title: 'Logout',
                  content: 'Are you sure you want to logout?',
                  buttonText: 'Yes',
                  onPressed: () {
                    HiveHelper.removeUser();
                    HiveHelper.removeId();
                    NotificationHelper.cancelDailyNotifications();
                    NotificationHelper.notificationData.clear();
                    HiveHelper.clearNotificationData();
                    Get.offAll(() => const LoginScreen());
                  });
            },
          ),
          //SizedBox(height: 12.h),
        ],
      ),
    );
  }
}
