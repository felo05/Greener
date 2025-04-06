part of 'similar_plants_cubit.dart';

@immutable
sealed class SimilarPlantsState {}

final class SimilarPlantsInitial extends SimilarPlantsState {}

final class SimilarPlantsSuccessState extends SimilarPlantsState {
  final PlantModel similarPlants;

  SimilarPlantsSuccessState(this.similarPlants);
}

final class SimilarPlantsErrorState extends SimilarPlantsState {
  final String message;

  SimilarPlantsErrorState(this.message);
}

final class SimilarPlantsLoadingState extends SimilarPlantsState {}
