import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:greener/feature/authentication/repository/authentication_repository_implementation.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  loginWithEmailAndPassword({required String email, required String password}) {
    emit(LoginLoadingState());
    AuthenticationRepositoryImplementation()
        .logInWithEmailAndPassword(email, password)
        .then((value) {
      if (value == null) {
        emit(LoginSuccessState());
      } else {
        emit(LoginErrorState(value.errorMessage));
      }
    });
  }
}
