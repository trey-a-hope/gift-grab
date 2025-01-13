part of 'leaderboard_bloc.dart';

abstract class LeaderboardState {}

class LeaderboardInitial extends LeaderboardState {}

class LeaderboardLoading extends LeaderboardState {}

class LeaderboardLoaded extends LeaderboardState {
  final List<LeaderboardEntry> entries;

  LeaderboardLoaded({required this.entries});
}

class LeaderboardActionSuccess extends LeaderboardState {
  final String message;

  LeaderboardActionSuccess({required this.message});
}

class LeaderboardError extends LeaderboardState {
  final String message;

  LeaderboardError({required this.message});
}
