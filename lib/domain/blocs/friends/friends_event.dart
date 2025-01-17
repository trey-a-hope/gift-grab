part of 'friends_bloc.dart';

sealed class FriendsEvent {
  const FriendsEvent();
}

class FetchFriends extends FriendsEvent {}
