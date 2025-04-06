import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';
import 'package:greener/core/constants/kcolors.dart';
import 'package:greener/core/widgets/back_appbar.dart';
import 'package:greener/core/widgets/custom_text.dart';
import 'package:greener/core/widgets/custom_text_snack_bar.dart';
import 'package:greener/core/widgets/favorite_icon.dart';
import 'package:greener/core/widgets/horizontal_products_header.dart';
import 'package:greener/core/widgets/loading_indicator.dart';
import 'package:greener/core/widgets/plant_card.dart';
import 'package:greener/feature/favorite/cubit/favorite_cubit.dart';
import 'package:greener/feature/home/model/plant_model.dart';
import 'package:greener/feature/my_garden/cubit/my_garden_cubit.dart';
import 'package:greener/feature/plant_details/cubit/plant_details/plant_details_cubit.dart';
import 'package:greener/feature/plant_details/model/plant_details_model.dart';
import 'package:greener/feature/vertical_plant_card_list/model/query_parameters_model.dart';

import '../../core/widgets/custom_network_image.dart';
import '../vertical_plant_card_list/vertical_plant_card_list_screen.dart';
import 'cubit/similar_plants/similar_plants_cubit.dart';

class PlantDetailsScreen extends StatelessWidget {
  const PlantDetailsScreen({super.key, required this.plantData});

  final PlantData plantData;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PlantDetailsCubit()..getPlantDetails(plantData.id!),
      child: Scaffold(
        backgroundColor: whitenColor,
        appBar: BackAppBar(
          title: plantData.commonName ??
              plantData.otherName?[0] ??
              'Plant Details',
          backgroundColor: baseColor,
          textColor: whitenColor,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeaderImage(),
              SizedBox(height: 16.h),
              CustomText(
                text: plantData.commonName ??
                    plantData.otherName?[0] ??
                    'Plant Details',
                textSize: 24,
                textColor: baseColor,
                textWeight: FontWeight.bold,
              ),
              _buildPlantDetailsSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.r),
      child: SizedBox(
        height: 200,
        width: double.infinity,
        child: Stack(
          children: [
            CustomNetworkImage(
              image:
                  plantData.defaultImage ?? 'https://via.placeholder.com/150',
              fit: BoxFit.cover,
            ),
            Positioned(
                top: 5,
                right: 5,
                child: BlocProvider(
                  create: (context) => FavoriteCubit(),
                  child: FavoriteIcon(plantData: plantData),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildPlantDetailsSection(BuildContext context) {
    return BlocConsumer<PlantDetailsCubit, PlantDetailsState>(
      listener: (context, state) {
        if (state is PlantDetailsErrorState) {
          CustomTextSnackBar(message: state.message);
        }
      },
      builder: (context, state) {
        if (state is PlantDetailsLoadingState) {
          return  Column(
            children: [
              SizedBox(height: 100.h),
              const Center(child: LoadingIndicator()),
            ],
          );
        }
        if (state is PlantDetailsErrorState) {
          return _buildErrorText(state.message);
        }
        if (state is PlantDetailsSuccessState) {
          return _buildPlantDetailsContent(context, state.plantDetailsModel);
        }
        return SizedBox(height: 100.h);
      },
    );
  }

  Widget _buildErrorText(String message) {
    return Padding(
      padding: EdgeInsets.only(top: 75.h),
      child: Center(
        child: CustomText(
          text: message,
          textSize: 16,
          textColor: baseColor,
        ),
      ),
    );
  }

  Widget _buildPlantDetailsContent(
      BuildContext context, PlantDetailsModel plantDetails) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (plantDetails.scientificName?.isNotEmpty ?? false)
          CustomText(
            text: plantDetails.scientificName!.join('\n'),
            textSize: 16,
            textColor: const Color(0xFF81C784),
          ),
        SizedBox(height: 8.h),
        if (plantDetails.description != null)
          CustomText(
            text: plantDetails.description!,
            textSize: 16,
            textColor: textColor,
            textAlign: TextAlign.justify,
          ),
        SizedBox(height: 16.h),
        _buildExpandableSection(
            "General Information", _buildGeneralInfo(plantDetails)),
        _buildExpandableSection("Watering and Sunlight",
            _buildWateringAndSunlightInfo(plantDetails)),
        _buildExpandableSection("Care Guides", _buildCareGuides(plantDetails)),
        if (plantDetails.plantAnatomy != null &&
            plantDetails.plantAnatomy!.isNotEmpty)
          _buildExpandableSection(
              "Plant Anatomy", _buildPlantAnatomySection(plantDetails)),
        _buildExpandableSection(
            "Additional Details", _buildAdditionalDetails(plantDetails)),
        _buildExpandableSection(
            "Other Characteristics", _buildOtherCharacteristics(plantDetails)),
        SizedBox(height: 8.h),
        BlocProvider(
          create: (context) => MyGardenCubit(),
          child: ChangeMyGarden(plantData: plantData),
        ),
        _buildRelatedPlantsSection(context, plantDetails),
      ],
    );
  }

  Widget _buildRelatedPlantsSection(
      BuildContext context, PlantDetailsModel plantDetails) {
    final plantQueryParameters = QueryParametersModel(
      indoor: plantDetails.indoor! ? 1 : 0,
      edible: plantDetails.edibleFruit! ? 1 : 0,
      poisonous: plantDetails.poisonousToHumans! ? 1 : 0,
      watering: plantDetails.watering,
      cycle: plantDetails.cycle,
    );

    return BlocProvider(
      create: (context) =>
          SimilarPlantsCubit()..getRelatedPlants(plantQueryParameters),
      child: BlocConsumer<SimilarPlantsCubit, SimilarPlantsState>(
        listener: (context, state) {
          if (state is SimilarPlantsErrorState) {
            CustomTextSnackBar(message: state.message);
          }
        },
        builder: (context, state) {
          if (state is SimilarPlantsLoadingState) {
            return const LoadingIndicator();
          }
          if (state is SimilarPlantsErrorState) {
            return _buildErrorText(state.message);
          }
          if (state is SimilarPlantsSuccessState) {
            return Column(
              children: [
                HorizontalProductsHeader(
                  text: "Similar Plants",
                  onPressedOnSeeMore: () {
                    Get.to(() => VerticalPlantCardListScreen(
                          title: "Similar Plants",
                          plants: state.similarPlants,
                          plantsQueryParameters: plantQueryParameters,
                        ));
                  },
                ),
                SizedBox(
                  height: 260.h,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: state.similarPlants.data!.length,
                    itemBuilder: (context, index) {
                      return SizedBox(
                        width: 225.w,
                        child: PlantCard(
                            plantData: state.similarPlants.data![index]),
                      );
                    },
                  ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildExpandableSection(String title, Widget content) {
    return ExpansionTile(
      title: CustomText(
        text: title,
        textSize: 18,
        textColor: baseColor,
        textWeight: FontWeight.bold,
      ),
      iconColor: baseColor,
      textColor: baseColor,
      children: [
        ConstrainedBox(
            constraints:
                BoxConstraints(minWidth: double.infinity, minHeight: 50.h),
            child: content)
      ],
    );
  }

  Widget _buildGeneralInfo(PlantDetailsModel plantDetails) {
    return _buildInfoColumn([
      _buildInfoRow("Family", plantDetails.family),
      _buildInfoRow("Origin", plantDetails.origin?.join('\n')),
      _buildInfoRow("Type", plantDetails.type),
      _buildInfoRow("Cycle", plantDetails.cycle),
      _buildInfoRow("Tropical", plantDetails.tropical == true ? "Yes" : "No"),
      _buildInfoRow("Maintenance", plantDetails.maintenance),
      (plantDetails.dimensions != null && plantDetails.dimensions!.type != null)
          ? _buildInfoRow(plantDetails.dimensions!.type!,
              "Up to ${plantDetails.dimensions!.maxValue} ${plantDetails.dimensions!.unit!}")
          : const SizedBox.shrink(),
    ]);
  }

  Widget _buildWateringAndSunlightInfo(PlantDetailsModel plantDetails) {
    return _buildInfoColumn([
      _buildInfoRow("Watering", plantDetails.watering),
      _buildInfoRow("Watering Period", plantDetails.wateringPeriod),
      if (plantDetails.wateringGeneralBenchmark?.value != null)
        _buildInfoRow("Watering General Benchmark",
            "${plantDetails.wateringGeneralBenchmark?.value} ${plantDetails.wateringGeneralBenchmark?.unit}"),
      if (plantDetails.depthWaterRequirement != null)
        _buildInfoRow("Depth Water Requirement",
            "${plantDetails.depthWaterRequirement?.value} ${plantDetails.depthWaterRequirement?.unit}"),
      if (plantDetails.volumeWaterRequirement?.value != null)
        _buildInfoRow("Volume Water Requirement",
            plantDetails.volumeWaterRequirement?.value),
      _buildInfoRow("Sunlight", plantDetails.sunlight?.join('\n')),
      _buildInfoRow("Soil", plantDetails.soil?.join('\n')),
    ]);
  }

  Widget _buildCareGuides(PlantDetailsModel plantDetails) {
    if (plantDetails.careGuides?.data == null) {
      return _buildInfoRow("Care Guides", "No care guides available");
    }
    return _buildInfoColumn([
      _buildInfoRow("Care Level", plantDetails.careLevel),
      _buildInfoRow(
          "Pest Susceptibility", plantDetails.pestSusceptibility?.join('\n')),
      _buildInfoRow("Pruning Month", plantDetails.pruningMonth?.join('\n')),
      if (plantDetails.pruningCount?.amount != null)
        _buildInfoRow("Pruning Count",
            "${plantDetails.pruningCount?.amount} ${plantDetails.pruningCount?.interval}"),
      ...plantDetails.careGuides!.data!.section!.map((section) =>
          _buildInfoRow(section.type ?? "", section.description ?? "")),
    ]);
  }

  Widget _buildAdditionalDetails(PlantDetailsModel plantDetails) {
    return _buildInfoColumn([
      _buildInfoRow("Growth Rate", plantDetails.growthRate),
      _buildInfoRow("Attracts", "${plantDetails.attracts?.join('\n')}"),
      _buildInfoRow("Propagation", plantDetails.propagation?.join('\n')),
      _buildInfoRow("Fruit", plantDetails.fruits == true ? "Yes" : "No"),
      if (plantDetails.fruits == true)
        _buildInfoRow(
            "Edible Fruit", plantDetails.edibleFruit == true ? "Yes" : "No"),
      _buildInfoRow("Fruit Color", plantDetails.fruitColor?.join('\n')),
      _buildInfoRow("Harvest Season", plantDetails.harvestSeason),
      _buildInfoRow("Cones", plantDetails.cones == true ? "Yes" : "No"),
      _buildInfoRow("Leaf", plantDetails.leaf == true ? "Yes" : "No"),
      if (plantDetails.leaf == true)
        _buildInfoRow(
            "Edible Leaf", plantDetails.edibleLeaf == true ? "Yes" : "No"),
      _buildInfoRow("Leaf Color", plantDetails.leafColor?.join('\n')),
      _buildInfoRow("Flowers", plantDetails.flowers == true ? "Yes" : "No"),
      _buildInfoRow("Flowering Season", plantDetails.floweringSeason),
      _buildInfoRow("Flower Color", plantDetails.flowerColor),
    ]);
  }

  Widget _buildOtherCharacteristics(PlantDetailsModel plantDetails) {
    return _buildInfoColumn([
      _buildInfoRow("Thorny", plantDetails.thorny == true ? "Yes" : "No"),
      _buildInfoRow("Indoor", plantDetails.indoor == true ? "Yes" : "No"),
      _buildInfoRow("Seed", plantDetails.seeds! ? "Yes" : "No"),
      _buildInfoRow("Medicinal", plantDetails.medicinal == true ? "Yes" : "No"),
      _buildInfoRow("Poisonous To Humans",
          plantDetails.poisonousToHumans! ? "Yes" : "No"),
      _buildInfoRow(
          "Poisonous To Pets", plantDetails.poisonousToPets! ? "Yes" : "No"),
      _buildInfoRow("Cuisine", plantDetails.cuisine == true ? "Yes" : "No"),
      _buildInfoRow("Invasive", plantDetails.invasive == true ? "Yes" : "No"),
      _buildInfoRow("Drought Tolerant",
          plantDetails.droughtTolerant == true ? "Yes" : "No"),
      _buildInfoRow(
          "Salt Tolerant", plantDetails.saltTolerant == true ? "Yes" : "No"),
    ]);
  }

  Widget _buildPlantAnatomySection(PlantDetailsModel plantDetails) {
    return _buildInfoColumn(plantDetails.plantAnatomy!
        .map((anatomyPart) => _buildInfoRow(
            anatomyPart.part ?? "", anatomyPart.color?.join('\n')))
        .toList());
  }

  Widget _buildInfoColumn(List<Widget> children) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch, children: children);
  }

  Widget _buildInfoRow(String title, String? value) {
    if (value == null || value.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomText(
            text: "$title: ",
            textSize: 18,
            textColor: baseColor,
            textWeight: FontWeight.bold,
          ),
          SizedBox(height: 5.h),
          CustomText(
            text: value,
            textSize: 16,
            textColor: textColor,
            textWeight: FontWeight.w600,
            textAlign: TextAlign.justify,
          ),
          SizedBox(height: 5.h),
        ],
      ),
    );
  }
}

class ChangeMyGarden extends StatefulWidget {
  const ChangeMyGarden({super.key, required this.plantData});

  final PlantData plantData;

  @override
  State<ChangeMyGarden> createState() => _ChangeMyGardenState();
}

class _ChangeMyGardenState extends State<ChangeMyGarden> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 45.h,
      decoration: BoxDecoration(
        color: baseColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: TextButton(
        onPressed: () {
          final myGardenCubit = context.read<MyGardenCubit>();
          widget.plantData.inMyGarden
              ? myGardenCubit.removeFromMyGarden(widget.plantData)
              : myGardenCubit.addToMyGarden(widget.plantData);
          widget.plantData.inMyGarden = !widget.plantData.inMyGarden;
          setState(() {});
        },
        child: CustomText(
          text:
              "${widget.plantData.inMyGarden ? "Remove from" : "Add to"} my Garden",
          textColor: whitenColor,
          textWeight: FontWeight.w600,
          textSize: 22,
        ),
      ),
    );
  }
}
