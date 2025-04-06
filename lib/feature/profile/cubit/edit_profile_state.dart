part of 'edit_profile_cubit.dart';

@immutable
sealed class EditProfileState {}

final class EditProfileInitial extends EditProfileState {}

final class EditProfileLoading extends EditProfileState {}

final class EditProfileError extends EditProfileState {
  final String errorMessage;

  EditProfileError(this.errorMessage);
}

final class EditProfileSuccess extends EditProfileState {
  final String? newName;
  final String? newImage;
  EditProfileSuccess({ this.newImage, this.newName});
}
