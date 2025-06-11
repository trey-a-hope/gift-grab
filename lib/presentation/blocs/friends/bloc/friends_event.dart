part of 'friends_bloc.dart';

sealed class FriendsEvent {
  const FriendsEvent();
}

class AddFriend extends FriendsEvent {
  final String uid;
  const AddFriend(this.uid);
}

class DeleteFriend extends FriendsEvent {
  final String uid;
  const DeleteFriend(this.uid);
}
