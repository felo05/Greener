import 'package:dartz/dartz.dart';
import 'package:greener/core/errors/api_errors.dart';

import '../../home/model/plant_model.dart';
import '../../vertical_plant_card_list/model/query_parameters_model.dart';
import '../model/plant_details_model.dart';

abstract class PlantDetailsRepository {
  Future<Either<Failure, PlantDetailsModel>> getPlantDetails(int plantId);

  Future<Either<Failure, PlantModel>> getSimilarPlant(QueryParametersModel plantQueryParameters);
}
