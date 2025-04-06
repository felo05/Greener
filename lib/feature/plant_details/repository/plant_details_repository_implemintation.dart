import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:greener/core/errors/api_errors.dart';
import 'package:greener/core/helpers/dio_helper.dart';
import 'package:greener/feature/plant_details/model/plant_details_model.dart';
import 'package:greener/feature/plant_details/repository/plant_details_repository.dart';
import 'package:greener/feature/vertical_plant_card_list/model/query_parameters_model.dart';

import '../../../core/constants/kapi.dart';
import '../../home/model/plant_model.dart';

class PlantDetailsRepositoryImplementation implements PlantDetailsRepository {
  @override
  Future<Either<Failure, PlantDetailsModel>> getPlantDetails(
      int plantId) async {
   try {
      final response = await DioHelpers.getData(
          path: '${KApi.species}/${KApi.details}/$plantId');
      PlantDetailsModel plant= (PlantDetailsModel.fromJson(response.data));
      await plant.fetchCareGuides(response.data['care-guides']);
      return Right(plant);
    }
    catch (e) {
      if (e is DioException) return Left(ServerFailure.fromDioError(e));
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PlantModel>> getSimilarPlant(
      QueryParametersModel plantQueryParameters) async {
    try {
      final response =
          await DioHelpers.getData(path: KApi.speciesList, queryParameters: plantQueryParameters.toJson());
      return Right(PlantModel.fromJson(response.data));
    } catch (e) {
      if (e is DioException) return Left(ServerFailure.fromDioError(e));
      return Left(ServerFailure(e.toString()));
    }
  }
}
