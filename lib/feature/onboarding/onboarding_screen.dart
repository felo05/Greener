import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:greener/core/constants/kcolors.dart';
import 'package:greener/core/helpers/hive_helper.dart';
import 'package:greener/core/widgets/custom_text.dart';
import 'package:greener/feature/authentication/login/login_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            "assets/images/Background.png",
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          Positioned(
            top: 20, // Adjust this value to set the vertical position
            left: 5, // Adjust this value to set the horizontal position
            child: Image.asset(
              "assets/images/White logo.png",
              height: 40.h,
            ),
          ),
          const OnboardingBody(),
        ],
      ),
    );
  }
}

class OnboardingBody extends StatefulWidget {
  const OnboardingBody({super.key});

  @override
  State<OnboardingBody> createState() => _OnboardingBodyState();
}

class _OnboardingBodyState extends State<OnboardingBody> {
  int counter = 1;
  List<Color> dotsColor = [
    const Color(0xff1BBC65),
    const Color(0xff28332D).withOpacity(.6),
  ];

  @override
  Widget build(BuildContext context) {
    const List<String> title = ["Welcome to Greener", "Grow Together"];
    const List<String> body = [
      "There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by  humour, or randomised words which don't look even slightly believable.",
      "It is always available to anyone, but the majority have suffered alteration in some form by  humour."
    ];
    const List<String> nextButton = ["Next", "Get Started"];
    const List<String> previousButton = ["Skip Intro", "Go Back"];

    return Center(
      child: Container(
        margin:
            EdgeInsets.only(left: 20.w, right: 20.w, bottom: 50.h, top: 60.h),
        padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 25.h),
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          color: whitenColor,
        ),
        child: Column(
          children: [
            SizedBox(
              height: 150.h,
              width: 212.w,
              child: SvgPicture.asset("assets/images/onboarding$counter.svg"),
            ),
            SizedBox(height: 12.h),
            CustomText(
                text: title[counter - 1],
                textSize: 24,
                textWeight: FontWeight.bold,
                textColor: const Color(0xff28332D)),
            SizedBox(height: 10.h),
            SizedBox(
              width: 253.w,
              height: 150.h,
              child: CustomText(
                  text: body[counter - 1],
                  textSize: 16,
                  textColor: const Color(0xff28332D).withOpacity(.6),
                  textAlign: TextAlign.justify),
            ),
            SizedBox(height: 30.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.circle,
                  size: 8.r,
                  color: dotsColor[0],
                ),
                SizedBox(width: 14.w),
                Icon(
                  Icons.circle,
                  size: 8.r,
                  color: dotsColor[1],
                ),
              ],
            ),
            const Spacer(),
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    if (counter == 1) {
                      HiveHelper.inFirstTime();
                      Get.offAll(() => const LoginScreen());
                    } else {
                      counter--;
                      dotsColor = dotsColor.reversed.toList();
                      setState(() {});
                    }
                  },
                  child: CustomText(
                      text: previousButton[counter - 1],
                      textSize: 16,
                      textColor: const Color(0xff28332D),
                      textWeight: FontWeight.w500),
                ),
                const Spacer(),
                InkWell(
                  onTap: () {
                    if (counter == 1) {
                      counter++;
                      dotsColor = dotsColor.reversed.toList();
                      setState(() {});
                    } else {
                      HiveHelper.inFirstTime();
                      Get.offAll(() => const LoginScreen());
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xff1BBC65),
                      borderRadius: BorderRadius.circular(5.r),
                    ),
                    width: 126.w,
                    height: 40.h,
                    child: Center(
                      child: CustomText(
                          text: nextButton[counter - 1],
                          textSize: 16,
                          textColor: whitenColor,
                          textWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
