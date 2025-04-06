import 'package:dartz/dartz.dart';

import '../../../core/errors/api_errors.dart';
import '../../home/model/plant_model.dart';

abstract class MyGardenRepository {
  void addPlant(PlantData plant);
  void removePlant(PlantData plant);
  Future<Either<List<PlantData>, Failure>> getPlants();
}