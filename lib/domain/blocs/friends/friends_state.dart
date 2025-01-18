part of 'friends_bloc.dart';

class FriendsState {
  final String? cursor;
  FriendsState({required this.cursor});
}

class FriendsInitial extends FriendsState {
  FriendsInitial({required super.cursor});
}

class FriendsLoading extends FriendsState {
  FriendsLoading({required super.cursor});
}

class FriendsLoaded extends FriendsState {
  final List<Friend> friends;

  FriendsLoaded({
    required this.friends,
    required super.cursor,
  });
}

class FriendsActionSuccess extends FriendsState {
  final String message;

  FriendsActionSuccess({
    required this.message,
    required super.cursor,
  });
}

class FriendsError extends FriendsState {
  final String message;

  FriendsError({
    required this.message,
    required super.cursor,
  });
}
