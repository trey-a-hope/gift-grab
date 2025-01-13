part of 'leaderboard_bloc.dart';

abstract class LeaderboardEvent {}

class FetchLeaderboard extends LeaderboardEvent {}

class SubmitScore extends LeaderboardEvent {
  final int score;

  SubmitScore({required this.score});
}
