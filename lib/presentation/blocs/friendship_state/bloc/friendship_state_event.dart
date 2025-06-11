part of 'friendship_state_bloc.dart';

sealed class FriendshipStateEvent {
  const FriendshipStateEvent();
}

class ListFriends extends FriendshipStateEvent {
  final bool clearCursor;
  const ListFriends({required this.clearCursor});
}

class CancelRequest extends FriendshipStateEvent {
  final String uid;
  const CancelRequest(this.uid);
}
