part of 'friend_bloc.dart';

class FriendState {
  final String? cursor;

  FriendState({
    required this.cursor,
  });
}

class FriendsInitial extends FriendState {
  FriendsInitial({
    required super.cursor,
  });
}

class FriendsLoading extends FriendState {
  FriendsLoading({
    required super.cursor,
  });
}

class FriendsLoaded extends FriendState {
  final List<Friend> friends;

  FriendsLoaded({
    required this.friends,
    required super.cursor,
  });
}

class FriendsSuccess extends FriendState {
  final String message;

  FriendsSuccess({
    required this.message,
    required super.cursor,
  });
}

class FriendsError extends FriendState {
  final String message;

  FriendsError({
    required this.message,
    required super.cursor,
  });
}