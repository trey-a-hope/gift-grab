part of 'friends_bloc.dart';

class FriendsState {}

class FriendsInitial extends FriendsState {}

class FriendsLoading extends FriendsState {}

class FriendsLoaded extends FriendsState {
  // final List<LeaderboardEntry> entries;

  // LeaderboardLoaded({required this.entries});
}

class FriendsActionSuccess extends FriendsState {
  final String message;

  FriendsActionSuccess({required this.message});
}

class FriendsError extends FriendsState {
  final String message;

  FriendsError({required this.message});
}
