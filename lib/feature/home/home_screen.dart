import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';
import 'package:greener/core/constants/kcolors.dart';
import 'package:greener/core/widgets/horizontal_products_header.dart';
import 'package:greener/feature/home/model/categories_model.dart';
import 'package:greener/feature/home/widgets/category_card.dart';

import '../../core/widgets/custom_text_field.dart';
import '../search/search_screen.dart';

class DiseaseAiService {
  Future<String> analyzeImage(Uint8List imageFile) async {
    try {
      final response = await Gemini.instance.prompt(parts: [
        Part.uint8List(imageFile),
        Part.text(
            "Analyze this image of a diseased plant and provide the following information:\n1- Identify the disease or pest affecting the plant.\n2- Explain the cause of the disease (e.g., fungal, bacterial, viral, or pest infestation).\n3- Recommend effective prevention methods to protect similar plants from this issue.\n4- Provide detailed treatment options, including organic and chemical solutions, to restore plant health.")
      ]);

      return response?.output ?? 'No response';
    } catch (e) {
      return 'Error, please try again';
    }
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whitenColor,
      appBar: AppBar(
        title: Image.asset('assets/images/White logo.png', height: 35.h),
        backgroundColor: baseColor,
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0.r),
        child: Column(
          children: [
            GestureDetector(
              child: const CustomTextField(
                isEnabled: false,
                prefixIcon: CupertinoIcons.search,
                text: "Search",
              ),
              onTap: () {
                Get.to(() => const SearchScreen());
              },
            ),
            SizedBox(height: 10.h),
            const HorizontalProductsHeader(
              text: "Categories",
              withSeeMore: false,
            ),
            SizedBox(height: 5.h),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.w,
                  mainAxisSpacing: 8.h,
                  //childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  return CategoryCard(
                    category: CategoriesModel.categoriesInHome[index],
                  );
                },
                itemCount: CategoriesModel.categoriesInHome.length,
              ),
            )
          ],
        ),
      ),
    );
  }
}
