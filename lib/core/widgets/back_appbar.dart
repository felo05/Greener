import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

import 'custom_text.dart';

class BackAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color backgroundColor;
  final void Function()? onPressBack;
  final Color textColor;

  const BackAppBar({
    super.key,
    required this.title,
    required this.backgroundColor,
    this.onPressBack,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      centerTitle: true,
      leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: textColor,
          ),
          onPressed: () {
            if (onPressBack != null) {
              onPressBack!();
            } else {
              Get.back();
            }
          }),
      title: CustomText(
        text: title,
        textSize: 22,
        textColor: textColor,
        textWeight: FontWeight.bold,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
