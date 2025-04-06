part of 'signup_cubit.dart';

@immutable
sealed class SignupState {}

final class SignupInitial extends SignupState {}

final class SignupLoadingState extends SignupState {}

final class SignupErrorState extends SignupState {
  final String message;

  SignupErrorState(this.message);
}

final class SignupSuccessState extends SignupState {}
