import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:gift_grab/data/services/nakama_service.dart';
import 'package:gift_grab/data/services/storage/base_storage_service.dart';
import 'package:gift_grab/domain/blocs/auth/auth_bloc.dart';
import 'package:gift_grab/presentation/models/leaderboard_entry.dart';
import 'package:grpc/grpc.dart';
import 'package:nakama/nakama.dart';

part 'leaderboard_event.dart';
part 'leaderboard_state.dart';

class LeaderboardBloc extends Bloc<LeaderboardEvent, LeaderboardState> {
  static const _leaderboardId = 'monthly_leaderboard';
  static const _tournamentId = 'daily_tournament';

  final AuthBloc authBloc;

  final NakamaService _nakamaService;
  final GamesPlayedStorage _gamesPlayedStorage;

  LeaderboardBloc({
    required this.authBloc,
  })  : _nakamaService = NakamaService(),
        _gamesPlayedStorage = GamesPlayedStorage(),
        super(LeaderboardInitial()) {
    on<FetchLeaderboard>(_onFetchLeaderboard);
    on<SubmitScore>(_onSubmitScore);
  }

  Future<void> _onFetchLeaderboard(
    FetchLeaderboard event,
    Emitter<LeaderboardState> emit,
  ) async {
    emit(LeaderboardLoading());

    try {
      final session = await _nakamaService.getValidSessionOrLogout(authBloc);

      final leaderboardRecordList =
          await getNakamaClient().listLeaderboardRecords(
        session: session,
        leaderboardName: _leaderboardId,
      );

      if (leaderboardRecordList.records == null) {
        emit(LeaderboardLoaded(entries: []));
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

        emit(LeaderboardLoaded(entries: results));
      }
    } on GrpcError catch (e) {
      emit(LeaderboardError(
          message: e.message ?? 'Unknown GRPC Error: ${e.codeName}'));
    } catch (e) {
      emit(LeaderboardError(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  Future<void> _onSubmitScore(
    SubmitScore event,
    Emitter<LeaderboardState> emit,
  ) async {
    emit(LeaderboardLoading());

    try {
      final session = await _nakamaService.getValidSessionOrLogout(authBloc);

      final uid = (await getNakamaClient().getAccount(session)).user.id;

      // Check and see if new score is the highest.
      final leaderboardRecordList =
          await getNakamaClient().listLeaderboardRecords(
        session: session,
        leaderboardName: _leaderboardId,
      );

      if (_isHighest(event.score, leaderboardRecordList.records)) {
        await getNakamaClient().rpc(
          session: session,
          id: Globals.rpc.notificationSend,
          payload: json.encode(
            {
              "subject": "You just got the highest record, ${event.score}!",
            },
          ),
        );
      }

      // Write new leaderboard record.
      await getNakamaClient().writeLeaderboardRecord(
        session: session,
        leaderboardName: _leaderboardId,
        score: event.score,
      );

      // Write tournament record.
      // Note: This currently throws an error if the tournament is not active;
      // but since the game bloc doesn't have a listener for errors, it's not shown on the front end.
      await getNakamaClient().writeTournamentRecord(
        session: session,
        tournamentId: _tournamentId,
        score: event.score,
      );

      final gamesPlayed = await _gamesPlayedStorage.getValue(session, uid);
      await _gamesPlayedStorage.updateValue(session, gamesPlayed + 1);

      debugPrint('_onSubmitScore: ${event.score}');

      emit(LeaderboardSuccess(message: 'Score submitted succesfully'));
    } on GrpcError catch (e) {
      emit(LeaderboardError(
          message: e.message ?? 'Unknown GRPC Error: ${e.codeName}'));
    } catch (e) {
      emit(LeaderboardError(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  bool _isHighest(int value, List<LeaderboardRecord>? records) {
    if (records == null || records.isEmpty) return true;

    for (LeaderboardRecord record in records) {
      if (record.score == null) continue;
      final score = int.parse(record.score!);
      if (score > value) return false;
    }
    return true;
  }
}
