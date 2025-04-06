import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:greener/feature/authentication/model/user_model.dart';

import '../../repository/authentication_repository_implementation.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit() : super(SignupInitial());

  void signupWithEmailAndPassword({
    required UserModel user,
    required String password,
    File? image,
  }) {
    emit(SignupLoadingState());
    AuthenticationRepositoryImplementation()
        .signUpWithEmailAndPassword(password: password, user: user,image: image)
        .then((value) {
      if (value == null) {
        emit(SignupSuccessState());
      } else {
        emit(SignupErrorState(value.errorMessage));
      }
    });
  }
}
