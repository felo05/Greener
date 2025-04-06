import 'package:dartz/dartz.dart';

import '../../../core/errors/api_errors.dart';

abstract class SearchRepository {
  Future<Either<Failure,dynamic>> search(String query,String topic,int page);
}