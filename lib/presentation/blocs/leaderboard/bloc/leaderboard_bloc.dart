import 'package:bloc/bloc.dart';
import 'package:gift_grab/data/services/nakama_session_service.dart';
import 'package:gift_grab/data/services/storage/games_played_storage.dart';
import 'package:gift_grab/presentation/blocs/auth/bloc/auth_bloc.dart';
import 'package:gift_grab/presentation/models/leaderboard_entry.dart';
import 'package:gift_grab/presentation/services/event_handler_service.dart';
import 'package:nakama/nakama.dart';

part 'leaderboard_event.dart';
part 'leaderboard_state.dart';

class LeaderboardBloc extends Bloc<LeaderboardEvent, LeaderboardState> {
  static const _leaderboardId = 'monthly_leaderboard';

  final AuthBloc authBloc;
  final NakamaSessionService _nakamaSessionService;
  final GamesPlayedStorage _gamesPlayedStorage;

  LeaderboardBloc(this.authBloc,
      {NakamaSessionService? nakamaSessionService,
      GamesPlayedStorage? gamesPlayedStorage})
      : _nakamaSessionService = nakamaSessionService ?? NakamaSessionService(),
        _gamesPlayedStorage = gamesPlayedStorage ?? GamesPlayedStorage(),
        super(const LeaderboardState()) {
    on<FetchLeaderboard>((event, emit) async {
      return await EventHandlerService.handleBlocEvent<LeaderboardState>(
        action: () async {
          emit(state.copyWith(isLoading: true));

          final session = (await _nakamaSessionService.getValidSession(
            requireValid: true,
            authBloc: authBloc,
          ))!;

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
        errorState: (message) => state.copyWith(error: message),
      );
    });
    on<SubmitScore>(
      (event, emit) async {
        return await EventHandlerService.handleBlocEvent<LeaderboardState>(
          action: () async {
            emit(state.copyWith(isLoading: true));

            final session = (await _nakamaSessionService.getValidSession(
              requireValid: true,
              authBloc: authBloc,
            ))!;

            await getNakamaClient().writeLeaderboardRecord(
              session: session,
              leaderboardName: _leaderboardId,
              score: event.score,
            );

            final gamesPlayed =
                await _gamesPlayedStorage.getValue(session, session.userId);
            await _gamesPlayedStorage.updateValue(session, gamesPlayed + 1);

            emit(state.copyWith());
          },
          emit: emit,
          errorState: (message) => state.copyWith(error: message),
        );
      },
    );
    on<DeleteRecord>((event, emit) async {
      return await EventHandlerService.handleBlocEvent<LeaderboardState>(
        action: () async {
          emit(state.copyWith(isLoading: true));

          final session = (await _nakamaSessionService.getValidSession(
            requireValid: true,
            authBloc: authBloc,
          ))!;

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
        errorState: (message) => state.copyWith(error: message),
      );
    });
  }
}
