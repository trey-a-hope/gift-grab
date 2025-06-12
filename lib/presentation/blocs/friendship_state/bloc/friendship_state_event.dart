part of 'friendship_state_bloc.dart';

sealed class FriendshipStateEvent {
  const FriendshipStateEvent();
}

class ListFriends extends FriendshipStateEvent {
  final bool clearCursor;
  const ListFriends({required this.clearCursor});
}

class AcceptIncomingRequest extends FriendshipStateEvent {
  final String uid;
  const AcceptIncomingRequest(this.uid);
}

class CancelOutgoingRequest extends FriendshipStateEvent {
  final String uid;
  const CancelOutgoingRequest(this.uid);
}

class RejectIncomingRequest extends FriendshipStateEvent {
  final String uid;
  const RejectIncomingRequest(this.uid);
}

class DeleteFriend extends FriendshipStateEvent {
  final String uid;
  const DeleteFriend(this.uid);
}

class BlockFriend extends FriendshipStateEvent {
  final String uid;
  const BlockFriend(this.uid);
}

class UnblockFriend extends FriendshipStateEvent {
  final String uid;
  const UnblockFriend(this.uid);
}
