part of 'leaderboard_bloc.dart';

abstract class LeaderboardEvent {}

class FetchLeaderboardEvent extends LeaderboardEvent {}

class SubmitScoreEvent extends LeaderboardEvent {
  final int score;

  SubmitScoreEvent({required this.score});
}
