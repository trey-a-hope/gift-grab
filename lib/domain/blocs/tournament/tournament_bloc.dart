import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_grab/data/services/nakama_service.dart';
import 'package:gift_grab/domain/blocs/auth/auth_bloc.dart';
import 'package:gift_grab/presentation/models/leaderboard_entry.dart';
import 'package:grpc/grpc.dart';
import 'package:nakama/nakama.dart';

part 'tournament_event.dart';
part 'tournament_state.dart';

class TournamentBloc extends Bloc<TournamentEvent, TournamentState> {
  final AuthBloc authBloc;
  final NakamaService _nakamaService;

  TournamentBloc(this.authBloc)
      : _nakamaService = NakamaService(),
        super(const TournamentState(cursor: null)) {
    on<FetchTournamentRecords>(_onFetchTournamentRecords);
  }

  Future<void> _onFetchTournamentRecords(
    FetchTournamentRecords event,
    Emitter<TournamentState> emit,
  ) async {
    emit(TournamentLoading(
      cursor: state.cursor,
    ));

    try {
      final session = await _nakamaService.getValidSessionOrLogout(authBloc);

      final tournamentRecordList =
          await getNakamaClient().listTournamentRecords(
        session: session,
        tournamentId: event.tournamentId,
        ownerIds: [],
      );

      final records = tournamentRecordList.records;

      final ownerIds = records
          .where((record) => record.ownerId != null)
          .map((record) => record.ownerId as String)
          .toList();

      final users = await getNakamaClient().getUsers(
        session: session,
        ids: ownerIds,
      );

      final results =
          records.where((record) => record.ownerId != null).map((record) {
        final user = users.firstWhere(
          (u) => u.id == record.ownerId,
          orElse: () =>
              throw Exception('No user found for ID: ${record.ownerId}'),
        );
        return LeaderboardEntry(record: record, user: user);
      }).toList();

      emit(
        TournamentLoaded(
          cursor: tournamentRecordList.nextCursor,
          entries: results,
        ),
      );
    } on GrpcError catch (e) {
      emit(TournamentError(
          cursor: state.cursor,
          message: e.message ?? 'Unknown GRPC Error: ${e.codeName}'));
    } catch (e) {
      emit(
        TournamentError(
          cursor: state.cursor,
          message: 'Unexpected error: ${e.toString()}',
        ),
      );
    }
  }
}
