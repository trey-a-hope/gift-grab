part of 'friends_bloc.dart';

sealed class FriendsEvent {
  const FriendsEvent();
}

class AddFriend extends FriendsEvent {
  final String uid;
  AddFriend({required this.uid});
}
