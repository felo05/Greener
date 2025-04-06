import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:greener/feature/plant_details/repository/plant_details_repository_implemintation.dart';
import '../../model/plant_details_model.dart';

part 'plant_details_state.dart';

class PlantDetailsCubit extends Cubit<PlantDetailsState> {
  PlantDetailsCubit() : super(PlantDetailsInitial());

  void getPlantDetails(int plantId) async {
    emit(PlantDetailsLoadingState());
    (await PlantDetailsRepositoryImplementation().getPlantDetails(plantId))
        .fold((failure) {
      emit(PlantDetailsErrorState(failure.errorMessage.toString()));
    }, (data) {
      emit(PlantDetailsSuccessState(data));
    });
  }
}
