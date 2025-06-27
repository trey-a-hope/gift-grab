import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gift_grab/domain/services/games_played_storage_service.dart';
import 'package:gift_grab/domain/services/session_service.dart';
import 'package:gift_grab/presentation/models/leaderboard_entry.dart';
import 'package:gift_grab_ui/bloc_handler.dart';
import 'package:nakama/nakama.dart';

part 'leaderboard_event.dart';
part 'leaderboard_state.dart';

class LeaderboardBloc extends Bloc<LeaderboardEvent, LeaderboardState> {
  static const _leaderboardId = 'monthly_leaderboard';

  final SessionService sessionService;
  final GamesPlayedStorageService gamesPlayedStorageService;

  LeaderboardBloc(
    this.sessionService,
    this.gamesPlayedStorageService,
  ) : super(const LeaderboardState()) {
    on<FetchLeaderboard>(_onFetchLeaderboard);
    on<SubmitScore>(_onSubmitScore);
    on<DeleteRecord>(_onDeleteRecord);
  }

  Future<void> _onFetchLeaderboard(
    FetchLeaderboard event,
    Emitter<LeaderboardState> emit,
  ) async =>
      await BlocHandler<LeaderboardState>().handle(
        action: () async {
          emit(state.copyWith(isLoading: true));

          final session = await sessionService.getSession();

          final leaderboardRecordList =
              await getNakamaClient().listLeaderboardRecords(
            session: session,
            leaderboardName: _leaderboardId,
          );

          if (leaderboardRecordList.records == null) {
            emit(state.copyWith());
          } else {
            final records = leaderboardRecordList.records!;

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

            emit(state.copyWith(entries: results));
          }
        },
        emit: emit,
        state: state,
      );

  Future<void> _onSubmitScore(
    SubmitScore event,
    Emitter<LeaderboardState> emit,
  ) async =>
      await BlocHandler<LeaderboardState>().handle(
        action: () async {
          emit(state.copyWith(isLoading: true));

          final session = await sessionService.getSession();

          await getNakamaClient().writeLeaderboardRecord(
            session: session,
            leaderboardName: _leaderboardId,
            score: event.score,
          );

          final gamesPlayed =
              await gamesPlayedStorageService.getValue(session, session.userId);
          await gamesPlayedStorageService.updateValue(session, gamesPlayed + 1);

          emit(state.copyWith());
        },
        emit: emit,
        state: state,
      );

  Future<void> _onDeleteRecord(
    DeleteRecord event,
    Emitter<LeaderboardState> emit,
  ) async =>
      await BlocHandler<LeaderboardState>().handle(
        action: () async {
          emit(state.copyWith(isLoading: true));

          final session = await sessionService.getSession();

          await getNakamaClient().deleteLeaderboardRecord(
            session: session,
            leaderboardName: _leaderboardId,
          );

          final entries = state.entries;

          entries.removeWhere(
            (i) => i.record.leaderboardId == _leaderboardId,
          );

          emit(state.copyWith(entries: entries));
        },
        emit: emit,
        state: state,
      );
}
