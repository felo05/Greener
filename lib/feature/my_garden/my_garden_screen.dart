import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:greener/core/widgets/custom_text.dart';
import 'package:greener/core/widgets/loading_indicator.dart';
import 'package:greener/core/widgets/vertical_card_list.dart';
import 'package:greener/feature/my_garden/cubit/my_garden_cubit.dart';

import '../../core/constants/kcolors.dart';

class MyGardenScreen extends StatelessWidget {
  const MyGardenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: baseColor,
        title: const CustomText(
          text: 'My Garden',
          textSize: 24,
          textWeight: FontWeight.bold,
          textColor: whitenColor,
        ),
      ),
      body: BlocProvider(
        create: (context) => MyGardenCubit()..getMyGardenPlants(),
        child: BlocBuilder<MyGardenCubit, MyGardenState>(
          builder: (context, state) {
            if (state is MyGardenLoadingState) {
              return const LoadingIndicator();
            }
            if (state is MyGardenSuccessState) {
              if (state.plants.isEmpty) {
                return const Center(
                    child: CustomText(
                  text: 'No plants in your garden',
                  textSize: 24,
                  textColor: baseColor,
                ));
              }

              return VerticalCardList(
                plants: state.plants,
              );
            }
            if (state is MyGardenErrorState) {
              return Center(
                  child: CustomText(
                text: state.message,
                textSize: 24,
                textColor: baseColor,
              ));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
