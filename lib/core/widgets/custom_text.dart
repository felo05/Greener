import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExpandableCustomText extends StatefulWidget {
  const ExpandableCustomText({
    super.key,
    required this.text,
    required this.textSize,
    required this.textWeight,
    this.textAlign,
    this.textColor,
    this.overflow,
    this.maxLines = 3,
  });

  final String text;
  final double textSize;
  final FontWeight textWeight;
  final Color? textColor;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int maxLines;

  @override
  ExpandableCustomTextState createState() => ExpandableCustomTextState();
}

class ExpandableCustomTextState extends State<ExpandableCustomText> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: widget.text,
          textAlign: widget.textAlign,
          overflow: widget.overflow,
          textColor: widget.textColor,
          textWeight: widget.textWeight,
          textSize: widget.textSize,
        ),
      ],
    );
  }
}

class CustomText extends StatelessWidget {
  const CustomText({
    super.key,
    required this.text,
    this.textSize = 16,
    this.textWeight,
    this.textAlign,
    this.textColor,
    this.overflow,
    this.maxLines,
    this.lineThrough = false,
  });

  final String text;
  final double textSize;
  final FontWeight? textWeight;
  final Color? textColor;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;
  final bool lineThrough;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
      style: TextStyle(
        decoration:
            lineThrough ? TextDecoration.lineThrough : TextDecoration.none,
        decorationColor: textColor,
        decorationThickness: 2,
        color: textColor,
        fontFamily: "Poppins",
        fontWeight: textWeight,
        fontSize: textSize.sp,
      ),
    );
  }
}
