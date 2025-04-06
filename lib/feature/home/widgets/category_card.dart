import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';
import 'package:greener/core/constants/kcolors.dart';
import 'package:greener/feature/home/model/categories_model.dart';
import 'package:greener/feature/vertical_plant_card_list/vertical_plant_card_list_screen.dart';

import '../../../core/widgets/custom_network_image.dart';
import '../../../core/widgets/custom_text.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
    required this.category,
  });

  final CategoriesModel category;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(() => VerticalPlantCardListScreen(
              title: category.name,
              plantsQueryParameters: category.queryParameters,
            ));
      },
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 100.h,
              child: CustomNetworkImage(
                image: category.image,
                fit: BoxFit.fitWidth,
              ),
            ),
            SizedBox(height: 8.h),
            CustomText(
              text: category.name,
              textSize: 16,
              textWeight: FontWeight.bold,
              textColor: baseColor,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 5.h),
          ],
        ),
      ),
    );
  }
}
