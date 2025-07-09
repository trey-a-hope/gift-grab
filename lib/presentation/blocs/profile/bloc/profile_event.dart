part of 'profile_bloc.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();
}

class ReadProfile extends ProfileEvent {
  const ReadProfile();

  @override
  List<Object?> get props => [];
}

class UsernameChange extends ProfileEvent {
  final String username;

  UsernameChange(this.username);

  @override
  List<Object?> get props => [username];
}

class UpdateProfile extends ProfileEvent {
  const UpdateProfile();

  @override
  List<Object?> get props => [];
}
