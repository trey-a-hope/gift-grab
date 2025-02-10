part of 'tournament_bloc.dart';

class TournamentState {
  final String? cursor;
  const TournamentState({required this.cursor});
}

class TournamentInitial extends TournamentState {
  TournamentInitial({required super.cursor});
}

class TournamentLoading extends TournamentState {
  TournamentLoading({required super.cursor});
}

class TournamentLoaded extends TournamentState {
  final List<LeaderboardEntry> entries;

  TournamentLoaded({required this.entries, required super.cursor});
}

class TournamentError extends TournamentState {
  final String message;

  TournamentError({
    required this.message,
    required super.cursor,
  });
}

class TournamentSuccess extends TournamentState {
  final String message;

  TournamentSuccess({
    required this.message,
    required super.cursor,
  });
}
