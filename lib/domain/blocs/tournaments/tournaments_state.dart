part of 'tournaments_bloc.dart';

class TournamentsState {
  final String? cursor;
  const TournamentsState({required this.cursor});
}

class TournamentsInitial extends TournamentsState {
  TournamentsInitial({required super.cursor});
}

class TournamentsLoading extends TournamentsState {
  TournamentsLoading({required super.cursor});
}

class TournamentsLoaded extends TournamentsState {
  final List<Tournament> tournaments;

  TournamentsLoaded({required this.tournaments, required super.cursor});
}

class TournamentsError extends TournamentsState {
  final String message;

  TournamentsError({
    required this.message,
    required super.cursor,
  });
}

class TournamentsSuccess extends TournamentsState {
  final String message;

  TournamentsSuccess({
    required this.message,
    required super.cursor,
  });
}
