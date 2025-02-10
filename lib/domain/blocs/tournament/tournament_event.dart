part of 'tournament_bloc.dart';

sealed class TournamentEvent {
  const TournamentEvent();
}

class FetchTournamentRecords extends TournamentEvent {
  final String tournamentId;
  FetchTournamentRecords({required this.tournamentId});
}

class FetchMoreTournamentRecords extends TournamentEvent {
  FetchMoreTournamentRecords();
}
