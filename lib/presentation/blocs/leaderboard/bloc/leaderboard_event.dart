part of 'leaderboard_bloc.dart';

sealed class LeaderboardEvent {
  const LeaderboardEvent();
}

class FetchLeaderboard extends LeaderboardEvent {}

class SubmitScore extends LeaderboardEvent {
  final int score;
  SubmitScore(this.score);
}

class DeleteRecord extends LeaderboardEvent {}
