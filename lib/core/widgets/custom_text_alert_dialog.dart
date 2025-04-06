import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greener/core/widgets/custom_text.dart';

class CustomTextAlertDialog  {
  final String title;
  final String content;
  final String buttonText;
  final void Function()? onPressed;

   CustomTextAlertDialog({
    required this.title,
    required this.content,
    required this.buttonText, this.onPressed,

  }){
     Get.defaultDialog(
      title: title,
      content: CustomText(text:content),
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: const CustomText(text:"Close"),
        ),
        onPressed != null ? TextButton(
          onPressed: () =>onPressed,
          child: CustomText(text:buttonText),
        ):const SizedBox.shrink(),
      ],
     );
   }


}