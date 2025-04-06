import 'package:flutter/material.dart';
import 'package:greener/core/widgets/loading_indicator.dart';
import 'package:greener/core/widgets/plant_card.dart';
import 'package:greener/feature/home/model/plant_model.dart';

class VerticalCardList extends StatelessWidget {
  const VerticalCardList({
    super.key,
    this.plants,
    this.scrollController,
    this.isLoadingMore = false,
  });

  final List<PlantData>? plants;
  final ScrollController? scrollController;
  final bool isLoadingMore;

  @override
  Widget build(BuildContext context) {
    final itemCount = (plants?.length ?? 0) + (isLoadingMore ? 1 : 0);

    return ListView.builder(
      controller: scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        if (index < (plants?.length ?? 0)) {
          return PlantCard(
            plantData: plants![index],
          );
        } else if (isLoadingMore) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: LoadingIndicator(),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}