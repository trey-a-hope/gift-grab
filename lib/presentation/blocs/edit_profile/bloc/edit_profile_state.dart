part of 'edit_profile_bloc.dart';

class EditProfileState {
  final ShortText username;

  final FormzSubmissionStatus status;

  EditProfileState({
    this.username = const ShortText.pure(),
    this.status = FormzSubmissionStatus.inProgress,
  });

  EditProfileState copyWith({
    ShortText? username,
    FormzSubmissionStatus? status,
  }) =>
      EditProfileState(
        username: username ?? this.username,
        status: status ?? this.status,
      );
}
