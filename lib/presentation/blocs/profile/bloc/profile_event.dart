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

class SendRequest extends ProfileEvent {
  const SendRequest();
}

class AcceptIncomingRequest extends ProfileEvent {
  const AcceptIncomingRequest();
}

class CancelOutgoingRequest extends ProfileEvent {
  const CancelOutgoingRequest();
}

class RejectIncomingRequest extends ProfileEvent {
  const RejectIncomingRequest();
}

class DeleteFriend extends ProfileEvent {
  const DeleteFriend();
}

class BlockFriend extends ProfileEvent {
  const BlockFriend();
}

class UnblockFriend extends ProfileEvent {
  const UnblockFriend();
}
