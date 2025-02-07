import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:gift_grab/data/services/nakama_service.dart';
import 'package:gift_grab/domain/blocs/auth/auth_bloc.dart';
import 'package:grpc/grpc.dart';
import 'package:nakama/nakama.dart';

part '../tournaments/tournaments_event.dart';
part '../tournaments/tournaments_state.dart';

class TournamentsBloc extends Bloc<TournamentsEvent, TournamentsState> {
  final AuthBloc authBloc;
  final NakamaService _nakamaService;

  static const _categoryStart = 1;
  static const _categoryEnd = _categoryStart + 1;

  TournamentsBloc({
    required this.authBloc,
  })  : _nakamaService = NakamaService(),
        super(const TournamentsState(cursor: null)) {
    on<FetchTournaments>(_onFetchTournaments);
    on<FetchMoreTournaments>(_onFetchMoreTournaments);
  }

  Future<void> _onFetchTournaments(
    FetchTournaments event,
    Emitter<TournamentsState> emit,
  ) async {
    emit(TournamentsLoading(cursor: state.cursor));

    try {
      final session = await _nakamaService.getValidSessionOrLogout(authBloc);

      final tournaments = await getNakamaClient().listTournaments(
        session: session,
        categoryStart: _categoryStart,
        categoryEnd: _categoryEnd,
        limit: Globals.paginationLimit,
      );

      final cursor = tournaments.cursor == '' ? null : tournaments.cursor;

      emit(TournamentsLoaded(
        tournaments: tournaments.tournaments,
        cursor: cursor,
      ));
    } on GrpcError catch (e) {
      emit(TournamentsError(
        message: e.message ?? 'Unknown GRPC Error: ${e.codeName}',
        cursor: state.cursor,
      ));
    } catch (e) {
      emit(
        TournamentsError(
          message: 'Unexpected error: ${e.toString()}',
          cursor: state.cursor,
        ),
      );
    }
  }

  Future<void> _onFetchMoreTournaments(
    FetchMoreTournaments event,
    Emitter<TournamentsState> emit,
  ) async {
    emit(TournamentsLoading(cursor: state.cursor));

    try {
      final session = await _nakamaService.getValidSessionOrLogout(authBloc);

      final tournaments = await getNakamaClient().listTournaments(
        session: session,
        categoryStart: _categoryStart,
        categoryEnd: _categoryEnd,
        limit: Globals.paginationLimit,
        cursor: state.cursor,
      );

      final cursor = tournaments.cursor == '' ? null : tournaments.cursor;

      emit(TournamentsLoaded(
        tournaments: tournaments.tournaments,
        cursor: cursor,
      ));
    } on GrpcError catch (e) {
      emit(TournamentsError(
        message: e.message ?? 'Unknown GRPC Error: ${e.codeName}',
        cursor: state.cursor,
      ));
    } catch (e) {
      emit(
        TournamentsError(
          message: 'Unexpected error: ${e.toString()}',
          cursor: state.cursor,
        ),
      );
    }
  }
}
