part of 'favorite_cubit.dart';

@immutable
sealed class FavoriteState {}

final class FavoriteInitial extends FavoriteState {}

final class FavoriteSuccessState extends FavoriteState {
  final List<PlantData> plants;

  FavoriteSuccessState(this.plants);
}

final class FavoriteErrorState extends FavoriteState {
  final String message;

  FavoriteErrorState(this.message);
}

final class FavoriteLoadingState extends FavoriteState {}
