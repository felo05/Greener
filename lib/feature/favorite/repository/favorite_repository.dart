import 'package:dartz/dartz.dart';
import 'package:greener/core/errors/api_errors.dart';
import 'package:greener/feature/home/model/plant_model.dart';

abstract class FavoriteRepository {
  void addFavorite(PlantData plant );
  void removeFavorite(PlantData plant);
  Future<Either<Failure,List<PlantData>>> getFavorites();
}