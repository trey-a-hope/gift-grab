import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gift_grab/util/config/providers.dart';
import 'package:nakama/nakama.dart';

class NakamaLeaderboardAsyncNotifier
    extends AsyncNotifier<List<LeaderboardRecord>> {
  final String _leaderboardName = 'weekly_leaderboard';

  @override
  FutureOr<List<LeaderboardRecord>> build() async {
    final nakamaSession =
        ref.read(Providers.nakamaSessionAsyncNotifierProvider);

    if (!nakamaSession.hasValue || nakamaSession.value == null) {
      throw Exception('No session available.');
    }

    final leaderboardRecordList =
        await getNakamaClient().listLeaderboardRecords(
      limit: 10,
      leaderboardName: _leaderboardName,
      session: nakamaSession.value!,
      // ownerIds: ['7bf0f4c0-0fde-4f57-995f-f9843351679c'],
      // ownerIds: ['d59c4636-ff71-4490-b58f-554ef1d63f43'],
    );

    final leaderboardRecords = leaderboardRecordList.records;

    return leaderboardRecords;
  }

  Future<void> writeLeaderboardRecord({
    required int score,
  }) async {
    try {
      final nakamaSession =
          ref.read(Providers.nakamaSessionAsyncNotifierProvider);

      if (!nakamaSession.hasValue || nakamaSession.value == null) {
        throw Exception('No session available.');
      }

      await getNakamaClient().writeLeaderboardRecord(
        session: nakamaSession.value!,
        leaderboardName: _leaderboardName,
        score: score,
      );
    } catch (e) {
      throw Exception(e);
    }
  }
}
