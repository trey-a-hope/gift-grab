part of 'friends_bloc.dart';

sealed class FriendsEvent {
  const FriendsEvent();
}

class FetchFriends extends FriendsEvent {}

class FetchMoreFriends extends FriendsEvent {
  final List<Friend> friends;

  FetchMoreFriends({required this.friends});
}

class DeleteFriend extends FriendsEvent {
  final String uid;
  DeleteFriend({required this.uid});
}

class AddFriend extends FriendsEvent {
  final String uid;
  AddFriend({required this.uid});
}

class BlockFriend extends FriendsEvent {
  final String uid;
  BlockFriend({required this.uid});
}
