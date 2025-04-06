import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:greener/core/constants/kapi.dart';
import 'package:greener/feature/home/model/plant_model.dart';
import 'package:greener/feature/search/repository/search_repository.dart';

import '../../../core/errors/api_errors.dart';
import '../../../core/helpers/dio_helper.dart';
import '../model/disease_model.dart';
import '../model/faq_model.dart';

class SearchRepositoryImplementation implements SearchRepository {

  @override
  Future<Either<Failure, dynamic>> search(String query,String topic,int page) async {
    try {
      final response =
          await DioHelpers.getData(path: topic, queryParameters: {
        'q': query,
        'page': page,
      });
      return topic==KApi.speciesList? Right(PlantModel.fromJson(response.data)):topic==KApi.disease? Right(DiseaseModel.fromJson(response.data)):Right(FaqModel.fromJson(response.data));
    } catch (e) {
      if (e is DioException) return Left(ServerFailure.fromDioError(e));
      return Left(ServerFailure(e.toString()));
    }
  }
}
