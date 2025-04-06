import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:greener/core/widgets/custom_network_image.dart';
import 'package:greener/feature/search/model/disease_model.dart';

import '../../../core/widgets/custom_text.dart';

class DiseaseCard extends StatelessWidget {
  const DiseaseCard({super.key, required this.diseaseData});

  final DiseaseData diseaseData;

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
                title: CustomText(
                  text: diseaseData.commonName ?? 'Disease',
                  textSize: 20,
                  textWeight: FontWeight.bold,
                ),
                content: SizedBox(
                  width: 300.w.clamp(200.0, MediaQuery.of(context).size.width * 0.9), // Responsive width
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildImageSection(diseaseData),
                        _buildBasicInfoSection(diseaseData),
                        _buildDescriptionsSection(diseaseData),
                        _buildSolutionsSection(diseaseData),
                      ],
                    ),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close'),
                  ),
                ],
              );
            });
      },
      child: Card(
        color: Colors.white,
        elevation: 4,
        margin: const EdgeInsets.all(8.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              child: SizedBox(
                height: 170,
                width: double.infinity,
                child: Stack(
                  children: [
                    CustomNetworkImage(
                      image: diseaseData.image ??
                          'https://via.placeholder.com/150',
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomText(
                text: diseaseData.commonName ?? '',
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
  Widget _buildImageSection(DiseaseData diseaseData) {
    if (diseaseData.image == null) return const SizedBox.shrink();
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: CustomNetworkImage(
        image: diseaseData.image!,
        fit: BoxFit.cover,
        height: 150.h,
        width: double.infinity,
      ),
    );
  }

// Basic Info Section
  Widget _buildBasicInfoSection(DiseaseData diseaseData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (diseaseData.commonName != null)
          ...[
            const CustomText(
              text: "Common name",
              textSize: 18,
              textWeight: FontWeight.bold,
            ),
            CustomText(
            text: diseaseData.commonName!,
            textSize: 18,
          )],
        if (diseaseData.scientificName != null)
          ...[
            const CustomText(
              text: "Scientific name",
              textSize: 18,
              textWeight: FontWeight.bold,
            ),
          CustomText(
            text: diseaseData.scientificName!,
            textSize: 18,
          )],
        if (diseaseData.otherName != null && diseaseData.otherName!.isNotEmpty)
          ...[
            const CustomText(
              text: "Other names",
              textSize: 18,
              textWeight: FontWeight.bold,),
          CustomText(
            text: diseaseData.otherName!.join(".\n"),
            textSize: 18,
          )],
        if (diseaseData.family != null)
          ...[
            const CustomText(
              text: "Family",
              textSize: 18,
              textWeight: FontWeight.bold,
            ),
          CustomText(
            text: diseaseData.family!,
            textSize: 18,
          ),],
        if (diseaseData.hosts != null && diseaseData.hosts!.isNotEmpty)
          ...[
            const CustomText(
              text: "Hosts",
              textSize: 18,
              textWeight: FontWeight.bold,
            ),
          CustomText(
            text: diseaseData.hosts!.join(", "),
            textSize: 18,
          )],
        if (diseaseData.commonName != null ||
            diseaseData.scientificName != null ||
            diseaseData.otherName?.isNotEmpty == true ||
            diseaseData.family != null ||
            diseaseData.hosts?.isNotEmpty == true)
          SizedBox(height: 10.h), // Spacer after basic info
      ],
    );
  }

// Descriptions Section
  Widget _buildDescriptionsSection(DiseaseData diseaseData) {
    if (diseaseData.descriptions == null || diseaseData.descriptions!.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CustomText(
          text: "Descriptions",
          textSize: 18,
          textWeight: FontWeight.bold,
        ),
        SizedBox(height: 5.h),
        ...diseaseData.descriptions!.map((desc) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: desc.title ?? '',
              textSize: 18,
              textWeight: FontWeight.w600,
              textAlign: TextAlign.justify,
            ),
            CustomText(
              text: desc.description ?? '',
              textSize: 16,
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 8.h),
          ],
        )),
      ],
    );
  }

// Solutions Section
  Widget _buildSolutionsSection(DiseaseData diseaseData) {
    if (diseaseData.solutions == null || diseaseData.solutions!.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CustomText(
          text: "Solutions",
          textSize: 18,
          textWeight: FontWeight.bold,
        ),
        SizedBox(height: 5.h),
        ...diseaseData.solutions!.map((solution) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: solution.title ?? '',
              textSize: 18,
              textWeight: FontWeight.w600,
            ),
            CustomText(
              text: solution.description ?? '',
              textSize: 16,
            ),
            SizedBox(height: 8.h),
          ],
        )),
      ],
    );
  }
}
