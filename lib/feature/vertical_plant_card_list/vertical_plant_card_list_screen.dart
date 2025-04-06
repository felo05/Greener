import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:greener/core/constants/kcolors.dart';
import 'package:greener/core/widgets/custom_text.dart';
import 'package:greener/core/widgets/vertical_card_list.dart';
import 'package:greener/feature/home/model/plant_model.dart';
import 'package:greener/feature/vertical_plant_card_list/cubit/vertical_plant_card_list_cubit.dart';
import 'package:greener/feature/vertical_plant_card_list/model/query_parameters_model.dart';
import '../../core/widgets/back_appbar.dart';

class VerticalPlantCardListScreen extends StatefulWidget {
  const VerticalPlantCardListScreen({
    super.key,
    required this.title,
    this.plants,
    required this.plantsQueryParameters,
  });

  final String title;
  final PlantModel? plants;
  final QueryParametersModel plantsQueryParameters;

  @override
  VerticalPlantCardListScreenState createState() => VerticalPlantCardListScreenState();
}

class VerticalPlantCardListScreenState extends State<VerticalPlantCardListScreen> {
  final ScrollController _scrollController = ScrollController();
  late VerticalPlantCardListCubit _cubit;
  late QueryParametersModel _queryParameters;

  @override
  void initState() {
    super.initState();
    _cubit = VerticalPlantCardListCubit();
    _queryParameters = widget.plantsQueryParameters.copyWith();
    _cubit.getPlantsByCategory(_queryParameters);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _cubit.close();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 500) {
      if (!_cubit.isLoading && !_cubit.hasReachedMax) {
        _queryParameters = _queryParameters.copyWith(
          page: (_queryParameters.page ?? 1) + 1,
        );
        _cubit.getPlantsByCategory(_queryParameters);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(
        title: widget.title,
        backgroundColor: baseColor,
        textColor: whitenColor,
      ),
      body: widget.plants != null
          ? VerticalCardList(plants: widget.plants?.data, scrollController: _scrollController)
          : BlocProvider(
        create: (context) => _cubit,
        child: BlocBuilder<VerticalPlantCardListCubit, VerticalPlantCardListState>(
          builder: (context, state) {
            if (state is VerticalPlantCardListLoadingState) {
              return const Center(
                child: CircularProgressIndicator(color: baseColor),
              );
            }
            if (state is VerticalPlantCardListErrorState) {
              return Center(
                child: CustomText(
                  text: state.errorMessage,
                  textSize: 18,
                  textColor: Colors.red,
                ),
              );
            }

            if (state is VerticalPlantCardListSuccessState) {
              return Column(
                children: [
                  Expanded(
                    child: VerticalCardList(
                      plants: state.plants.data,
                      scrollController: _scrollController,
                      isLoadingMore: _cubit.isLoading,
                    ),
                  ),
                  if (_cubit.hasReachedMax)
                    Padding(
                      padding: EdgeInsets.all(8.0.r),
                      child: const Text("No more plants to load"),
                    ),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}