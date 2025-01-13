import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_grab/data/services/nakama_service.dart';
import 'package:gift_grab/domain/blocs/auth/auth_bloc.dart';
import 'package:gift_grab/domain/mixins/grpc_error_handler_mixin.dart';
import 'package:gift_grab/presentation/models/leaderboard_entry.dart';
import 'package:grpc/grpc.dart';
import 'package:nakama/nakama.dart';

part 'leaderboard_event.dart';
part 'leaderboard_state.dart';

class LeaderboardBloc extends Bloc<LeaderboardEvent, LeaderboardState>
    with GrpcErrorHandlerMixin<LeaderboardState> {
  final AuthBloc authBloc;

  final _leaderboardName = 'weekly_leaderboard';
  final NakamaService _nakamaService;

  LeaderboardBloc({
    required this.authBloc,
  })  : _nakamaService = NakamaService(),
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
      if (session == null) return;

      final leaderboard = await getNakamaClient().listLeaderboardRecords(
        session: session,
        leaderboardName: _leaderboardName,
      );

      if (leaderboard.records == null) {
        emit(LeaderboardLoaded(entries: []));
      } else {
        final records = leaderboard.records!;

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
      handleGrpcError(e, emit, (message) => LeaderboardError(message: message));
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
      if (session == null) return;

      debugPrint('Score: ${event.score}');

      await getNakamaClient().writeLeaderboardRecord(
        session: session,
        leaderboardName: _leaderboardName,
        score: event.score,
      );

      emit(LeaderboardActionSuccess(message: 'Score submitted succesfully'));
    } on GrpcError catch (e) {
      handleGrpcError(e, emit, (message) => LeaderboardError(message: message));
    } catch (e) {
      emit(LeaderboardError(message: 'Unexpected error: ${e.toString()}'));
    }
  }
}
