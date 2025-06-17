part of 'friendship_group_bloc.dart';

sealed class FriendshipGroupEvent {
  const FriendshipGroupEvent();
}

class ListFriends extends FriendshipGroupEvent {
  final bool clearCursor;
  const ListFriends({required this.clearCursor});
}

class AcceptIncomingRequest extends FriendshipGroupEvent {
  final String uid;
  const AcceptIncomingRequest(this.uid);
}

class CancelOutgoingRequest extends FriendshipGroupEvent {
  final String uid;
  const CancelOutgoingRequest(this.uid);
}

class RejectIncomingRequest extends FriendshipGroupEvent {
  final String uid;
  const RejectIncomingRequest(this.uid);
}

class DeleteFriend extends FriendshipGroupEvent {
  final String uid;
  const DeleteFriend(this.uid);
}
