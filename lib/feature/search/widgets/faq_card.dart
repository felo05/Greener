import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:greener/core/widgets/custom_network_image.dart';

import '../model/faq_model.dart';
import '../../../core/widgets/custom_text.dart';

class FaqCard extends StatelessWidget {
  const FaqCard({super.key, required this.faqData});

  final FaqData faqData;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              insetPadding: EdgeInsets.all(20.r),
              scrollable: true,
              title: CustomText(text:faqData.question ?? "FAQ", textSize: 20,textWeight: FontWeight.bold,),
              content: SizedBox(
                width: 300.w, // Set a finite width (adjust as needed)
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (faqData.image != null)
                      Padding(
                        padding: EdgeInsets.only(bottom: 10.h),
                        child: CustomNetworkImage(
                          image: faqData.image!,
                          fit: BoxFit.cover,
                          height: 150.h,
                          width: double.infinity, // Works now because parent has finite width
                        ),
                      ),
                    CustomText(text: faqData.answer ?? "No answer available", textSize: 18,textAlign: TextAlign.justify,),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Close"),
                ),
              ],
            );
          },
        );
      },
      child: Card(
        color: Colors.white,
        elevation: 4,
        margin: EdgeInsets.all(8.0.r),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
              child: SizedBox(
                height: 170.h,
                width: double.infinity,
                child: Stack(
                  children: [
                    CustomNetworkImage(
                      image: faqData.image ?? 'https://via.placeholder.com/150',
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0.r),
              child: CustomText(
                text: faqData.question ?? '',
                textSize: 16,
                textColor: Colors.black,
                textWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}