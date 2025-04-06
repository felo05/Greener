import 'package:dartz/dartz.dart';
import 'package:greener/core/errors/api_errors.dart';
import 'package:greener/feature/home/model/plant_model.dart';

import '../model/query_parameters_model.dart';


abstract class VerticalPlantCardListRepository {
  Future<Either<Failure,PlantModel>> getPlantsByCategory(final QueryParametersModel plantQueryParameters);
}