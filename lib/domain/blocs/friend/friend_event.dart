part of 'friend_bloc.dart';

sealed class FriendEvent {}


class FetchFriends extends FriendEvent {}

class FetchMoreFriends extends FriendEvent {}


class CreateFriend extends FriendEvent {
  final Map<String, dynamic> data;

  CreateFriend({required this.data});
}


class ReadFriend extends FriendEvent {
  final String id;

  ReadFriend({required this.id});
}


class UpdateFriend extends FriendEvent {
  final String id;
  final Map<String, dynamic> data;

  UpdateFriend({
    required this.id,
    required this.data,
  });
}


class DeleteFriend extends FriendEvent {
  final String id;

  DeleteFriend({required this.id});
}
