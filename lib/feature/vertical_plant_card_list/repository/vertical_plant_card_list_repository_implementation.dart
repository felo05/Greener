import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:greener/core/constants/kapi.dart';
import 'package:greener/core/helpers/dio_helper.dart';
import 'package:greener/feature/vertical_plant_card_list/repository/vertical_plant_card_list_repository.dart';

import '../../../../core/errors/api_errors.dart';
import '../../home/model/plant_model.dart';
import '../model/query_parameters_model.dart';

class VerticalPlantCardListRepositoryImplementation
    extends VerticalPlantCardListRepository {
  @override
  Future<Either<Failure, PlantModel>> getPlantsByCategory(
      QueryParametersModel plantQueryParameters) async {
    try {
      final response=await DioHelpers.getData(
          path: KApi.speciesList, queryParameters: plantQueryParameters.toJson());
      return Right(PlantModel.fromJson(response.data));
    } catch (e) {
      if (e is DioException) return Left(ServerFailure.fromDioError(e));
      return Left(ServerFailure(e.toString()));
    }
  }
}
