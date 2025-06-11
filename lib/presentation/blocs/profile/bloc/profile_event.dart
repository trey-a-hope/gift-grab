part of 'profile_bloc.dart';

sealed class ProfileEvent {
  const ProfileEvent();
}

class ReadProfile extends ProfileEvent {}

class UsernameChange extends ProfileEvent {
  final String username;
  UsernameChange(this.username);
}

class UpdateProfile extends ProfileEvent {}

class SendRequest extends ProfileEvent {}

class CancelRequest extends ProfileEvent {}
