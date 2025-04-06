part of 'vertical_plant_card_list_cubit.dart';

@immutable
sealed class VerticalPlantCardListState {}

final class VerticalPlantCardListInitial extends VerticalPlantCardListState {}

final class VerticalPlantCardListErrorState extends VerticalPlantCardListState {
  final String errorMessage;

  VerticalPlantCardListErrorState(this.errorMessage);
}

final class VerticalPlantCardListLoadingState extends VerticalPlantCardListState {}


final class VerticalPlantCardListSuccessState extends VerticalPlantCardListState {
  final PlantModel plants;

  VerticalPlantCardListSuccessState(this.plants);
}
