import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:greener/core/constants/kcolors.dart';
import 'package:greener/feature/favorite/cubit/favorite_cubit.dart';

import '../../core/widgets/custom_text.dart';
import '../../core/widgets/loading_indicator.dart';
import '../../core/widgets/vertical_card_list.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: baseColor,
        title: const CustomText(
          text: 'Favorite',
          textSize: 24,
          textWeight: FontWeight.bold,
          textColor: whitenColor,
        ),
      ),
      body: BlocProvider(
        create: (context) => FavoriteCubit()..getFavoritePlants(),
        child: BlocBuilder<FavoriteCubit, FavoriteState>(
          builder: (context, state) {
            if (state is FavoriteLoadingState) {
              return const LoadingIndicator();
            }
            if (state is FavoriteSuccessState) {
              if (state.plants.isEmpty) {
                return const Center(
                    child: CustomText(
                  text: 'No favorite plants yet',
                  textSize: 24,
                  textColor: baseColor,
                ));
              }

              return VerticalCardList(
                plants: state.plants,
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
