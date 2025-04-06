import 'package:dartz/dartz.dart';
import 'package:greener/core/errors/api_errors.dart';
import 'package:greener/feature/authentication/model/user_model.dart';

abstract class AuthenticationRepository {
  Future<Either<String,Failure>> authenticateWithGoogle();

  Future<Failure?> logInWithEmailAndPassword(String email, String password);

  Future<Failure?> signUpWithEmailAndPassword(
      {required UserModel user, required String password});
}
