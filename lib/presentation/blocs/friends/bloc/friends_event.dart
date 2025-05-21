part of 'friends_bloc.dart';

sealed class FriendsEvent {
  const FriendsEvent();
}

class AddFriend extends FriendsEvent {
  final String uid;
  const AddFriend({required this.uid});
}

class FetchFriends extends FriendsEvent {}
