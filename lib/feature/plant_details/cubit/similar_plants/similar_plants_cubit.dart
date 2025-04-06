import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:greener/feature/vertical_plant_card_list/model/query_parameters_model.dart';

import '../../../home/model/plant_model.dart';
import '../../repository/plant_details_repository_implemintation.dart';

part 'similar_plants_state.dart';

class SimilarPlantsCubit extends Cubit<SimilarPlantsState> {
  SimilarPlantsCubit() : super(SimilarPlantsInitial());

  void getRelatedPlants(QueryParametersModel plantQueryParameters) async {
    emit(SimilarPlantsLoadingState());
    (await PlantDetailsRepositoryImplementation().getSimilarPlant(plantQueryParameters)).fold(
        (failure) {
      emit(SimilarPlantsErrorState(failure.errorMessage.toString()));
    }, (data) {
      emit(SimilarPlantsSuccessState(data));
    });
  }
}
