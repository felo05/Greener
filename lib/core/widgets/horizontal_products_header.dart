import 'package:flutter/material.dart';
import 'package:greener/core/constants/kcolors.dart';

import 'custom_text.dart';

class HorizontalProductsHeader extends StatelessWidget {
  final String text;
  final Function()? onPressedOnSeeMore;
  final bool withSeeMore;

  const HorizontalProductsHeader(
      {super.key,
      required this.text,
      this.onPressedOnSeeMore,
      this.withSeeMore = true});

  @override
  Row build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
            text: text,
            textSize: 20,
            textWeight: FontWeight.bold,
            textColor: baseColor),
        withSeeMore
            ? TextButton(
                onPressed: onPressedOnSeeMore,
                child: const CustomText(
                    text: "See more",
                    textSize: 17,
                    textWeight: FontWeight.w500,
                    textColor: baseColor))
            : const SizedBox.shrink()
      ],
    );
  }
}
