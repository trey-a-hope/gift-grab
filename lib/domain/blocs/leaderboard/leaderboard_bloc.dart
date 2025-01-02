import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_grab/data/services/nakama_service.dart';
import 'package:nakama/nakama.dart';

part 'leaderboard_event.dart';
part 'leaderboard_state.dart';

class LeaderboardBloc extends Bloc<LeaderboardEvent, LeaderboardState> {
  final _leaderboardName = 'weekly_leaderboard';

  LeaderboardBloc() : super(LeaderboardInitial()) {
    on<FetchLeaderboardEvent>(_onFetchLeaderboardEvent);
    on<SubmitScoreEvent>(_onSubmitScoreEvent);
  }

  Future<void> _onFetchLeaderboardEvent(
    FetchLeaderboardEvent event,
    Emitter<LeaderboardState> emit,
  ) async {
    emit(LeaderboardLoading());

    try {
      final session = await NakamaService().getValidSession();

      if (session == null) {
        throw Exception('Session expired...');
      } else {
        final leaderboard = await getNakamaClient().listLeaderboardRecords(
          session: session,
          leaderboardName: _leaderboardName,
        );

        emit(LeaderboardLoaded(entries: leaderboard.records ?? []));
      }
    } catch (e) {
      emit(LeaderboardError(message: e.toString()));
    }
  }

  Future<void> _onSubmitScoreEvent(
    SubmitScoreEvent event,
    Emitter<LeaderboardState> emit,
  ) async {
    emit(LeaderboardLoading());

    try {
      debugPrint('Score: ${event.score}');

      final session = await NakamaService().getValidSession();

      if (session == null) {
        throw Exception('Session expired...');
      } else {
        await getNakamaClient().writeLeaderboardRecord(
          session: session,
          leaderboardName: _leaderboardName,
          score: event.score,
        );

        // Refresh leaderboard after updating
        add(FetchLeaderboardEvent());
      }
    } catch (e) {
      emit(LeaderboardError(message: e.toString()));
    }
  }
}
