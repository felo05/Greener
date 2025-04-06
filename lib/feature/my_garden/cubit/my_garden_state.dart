part of 'my_garden_cubit.dart';

@immutable
sealed class MyGardenState {}

final class MyGardenInitial extends MyGardenState {}

final class MyGardenErrorState extends MyGardenState {
  final String message;

  MyGardenErrorState(this.message);
}

final class MyGardenLoadingState extends MyGardenState {}

final class MyGardenSuccessState extends MyGardenState {
  final List<PlantData> plants;

  MyGardenSuccessState(this.plants);
}
