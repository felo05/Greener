import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';
import 'package:greener/core/constants/kcolors.dart';

import '../../feature/favorite/cubit/favorite_cubit.dart';
import '../../feature/home/model/plant_model.dart';
import '../../feature/plant_details/plant_details_screen.dart';
import 'custom_network_image.dart';
import 'favorite_icon.dart';

class PlantCard extends StatelessWidget {
  const PlantCard({
    super.key,
    required this.plantData,
  });

  final PlantData plantData;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() =>
            PlantDetailsScreen(
              plantData: plantData,
            ));
      },
      child: Card(
        color: whitenColor,
        elevation: 4,
        margin: EdgeInsets.all(8.0.r),
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
              child: SizedBox(
                height: 135.h,
                width: double.infinity,
                child: Stack(
                  children: [
                    CustomNetworkImage(
                      image: plantData.defaultImage ??
                          'https://via.placeholder.com/150',
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      top: 5,
                      right: 5,
                      child: BlocProvider(
                        create: (context) => FavoriteCubit(),
                        child: FavoriteIcon(plantData: plantData),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    plantData.commonName ?? 'Unknown Plant',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff37474F)),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    plantData.scientificName?.join(', ') ??
                        'Scientific name not available',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Color(0xFF81C784),
                    ),
                    maxLines: 1,
                  ),
                  SizedBox(height: 5.h),
                  if (plantData.cycle != null)
                    Text(
                      'Cycle: ${plantData.cycle}',
                      style: const TextStyle(color: textColor),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  if (plantData.watering != null)
                    Text(
                      'Watering: ${plantData.watering}',
                      style: const TextStyle(color: textColor),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  if (plantData.sunlight != null &&
                      plantData.sunlight!.isNotEmpty)
                    Text(
                      'Sunlight: ${plantData.sunlight!.join(', ')}',
                      style: const TextStyle(color: textColor),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
