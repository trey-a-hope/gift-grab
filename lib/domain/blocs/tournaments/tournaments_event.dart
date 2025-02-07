part of 'tournaments_bloc.dart';

sealed class TournamentsEvent {
  const TournamentsEvent();
}

class FetchTournaments extends TournamentsEvent {}

class FetchMoreTournaments extends TournamentsEvent {
  final List<Tournament> tournaments;

  FetchMoreTournaments({required this.tournaments});
}
