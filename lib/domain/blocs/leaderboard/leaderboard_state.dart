part of 'leaderboard_bloc.dart';

abstract class LeaderboardState {
  final bool isLoading;

  LeaderboardState({required this.isLoading});
}

class LeaderboardInitial extends LeaderboardState {
  LeaderboardInitial() : super(isLoading: false);
}

class LeaderboardLoading extends LeaderboardState {
  LeaderboardLoading() : super(isLoading: true);
}

class LeaderboardLoaded extends LeaderboardState {
  final List<LeaderboardRecord> entries;

  LeaderboardLoaded({required this.entries}) : super(isLoading: false);
}

class LeaderboardError extends LeaderboardState {
  final String message;

  LeaderboardError({required this.message}) : super(isLoading: false);
}
