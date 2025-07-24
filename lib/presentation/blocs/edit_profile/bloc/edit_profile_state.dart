part of 'edit_profile_bloc.dart';

class EditProfileState extends Equatable implements ErrorState {
  final ShortText username;
  final FormzSubmissionStatus status;
  final String? error;

  const EditProfileState({
    this.username = const ShortText.pure(),
    this.status = FormzSubmissionStatus.inProgress,
    this.error,
  });

  EditProfileState copyWith({
    ShortText? username,
    FormzSubmissionStatus? status,
    String? error,
  }) =>
      EditProfileState(
        username: username ?? this.username,
        status: status ?? this.status,
        error: error,
      );

  @override
  List<Object?> get props => [username, status, error];
}
