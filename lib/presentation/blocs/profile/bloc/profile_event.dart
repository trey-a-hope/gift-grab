part of 'profile_bloc.dart';

sealed class ProfileEvent {
  const ProfileEvent();
}

class ReadProfile extends ProfileEvent {
  const ReadProfile();
}

class UsernameChange extends ProfileEvent {
  final String username;
  UsernameChange(this.username);
}

class UpdateProfile extends ProfileEvent {
  const UpdateProfile();
}

class SendRequest extends ProfileEvent {}

class AcceptIncomingRequest extends ProfileEvent {}

class CancelOutgoingRequest extends ProfileEvent {}

class RejectIncomingRequest extends ProfileEvent {}

class DeleteFriend extends ProfileEvent {}

class BlockFriend extends ProfileEvent {}

class UnblockFriend extends ProfileEvent {}
