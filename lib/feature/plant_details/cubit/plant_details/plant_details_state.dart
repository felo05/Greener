part of 'plant_details_cubit.dart';

@immutable
sealed class PlantDetailsState {}

final class PlantDetailsInitial extends PlantDetailsState {}

final class PlantDetailsLoadingState extends PlantDetailsState {}

final class PlantDetailsSuccessState extends PlantDetailsState {
  final PlantDetailsModel plantDetailsModel;

  PlantDetailsSuccessState(this.plantDetailsModel);
}

final class PlantDetailsErrorState extends PlantDetailsState {
  final String message;

  PlantDetailsErrorState(this.message);
}