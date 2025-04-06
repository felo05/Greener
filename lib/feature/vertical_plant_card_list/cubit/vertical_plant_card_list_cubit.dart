import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:greener/feature/home/model/plant_model.dart';
import 'package:greener/feature/vertical_plant_card_list/model/query_parameters_model.dart';
import 'package:greener/feature/vertical_plant_card_list/repository/vertical_plant_card_list_repository_implementation.dart';

part 'vertical_plant_card_list_state.dart';

class VerticalPlantCardListCubit extends Cubit<VerticalPlantCardListState> {
  VerticalPlantCardListCubit() : super(VerticalPlantCardListInitial());

  final List<PlantData> _plants = [];
  bool _hasReachedMax = false;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  bool get hasReachedMax => _hasReachedMax;

  void getPlantsByCategory(QueryParametersModel plantsQueryParameters) async {
    if (_hasReachedMax || _isLoading) return;

    _isLoading = true;

    if (_plants.isEmpty) {
      emit(VerticalPlantCardListLoadingState());
    }else{
      emit(VerticalPlantCardListSuccessState(PlantModel(data: List.from(_plants))));
    }

    final result = await VerticalPlantCardListRepositoryImplementation()
        .getPlantsByCategory(plantsQueryParameters);

    _isLoading = false;
    result.fold(
      (failure) {
        emit(VerticalPlantCardListErrorState(failure.errorMessage));
      },
      (data) {
        if (data.data == null || data.data!.isEmpty) {
          _hasReachedMax = true;
        } else {
          _plants.addAll(data.data!);
        }
        emit(VerticalPlantCardListSuccessState(
            PlantModel(data: List.from(_plants))));
      },
    );
  }
}
