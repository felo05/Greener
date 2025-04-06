import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:greener/feature/favorite/repository/favorite_repository_implementation.dart';
import 'package:greener/feature/home/model/plant_model.dart';

part 'favorite_state.dart';
class FavoriteCubit extends Cubit<FavoriteState> {
  FavoriteCubit() : super(FavoriteInitial());

  List<PlantData> _favoritePlants = [];

  final FavoriteRepositoryImplementation _favoriteRepositoryImplementation =
  FavoriteRepositoryImplementation();
  void getFavoritePlants() async {
    emit(FavoriteLoadingState());

    (await _favoriteRepositoryImplementation.getFavorites()).fold((failure) {
      emit(FavoriteErrorState(failure.errorMessage.toString()));
    }, (data) {
      _favoritePlants = data;
      emit(FavoriteSuccessState(_favoritePlants));
    });
  }

  void addToFavorite(PlantData plant) {
    _favoriteRepositoryImplementation.addFavorite(plant);
    _favoritePlants.add(plant);
    emit(FavoriteSuccessState(_favoritePlants));
  }

  void removeFromFavorite(PlantData plant) {
    _favoriteRepositoryImplementation.removeFavorite(plant);
    _favoritePlants.removeWhere((p) => p.id == plant.id);
    emit(FavoriteSuccessState(_favoritePlants));
  }
}