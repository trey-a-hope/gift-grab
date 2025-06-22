part of 'edit_profile_bloc.dart';

class EditProfileState {
  final Name username;

  final FormzSubmissionStatus status;

  EditProfileState({
    this.username = const Name.pure(),
    this.status = FormzSubmissionStatus.inProgress,
  });

  EditProfileState copyWith({
    Name? username,
    FormzSubmissionStatus? status,
  }) =>
      EditProfileState(
        username: username ?? this.username,
        status: status ?? this.status,
      );
}
