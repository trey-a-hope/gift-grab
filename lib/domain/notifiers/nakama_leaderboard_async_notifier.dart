import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gift_grab/util/config/providers.dart';
import 'package:nakama/nakama.dart';

class NakamaLeaderboardAsyncNotifier
    extends AsyncNotifier<List<LeaderboardRecord>> {
  static const String leaderboardName = 'weekly_leaderboard';

  @override
  FutureOr<List<LeaderboardRecord>> build() async {
    final nakamaClient = ref.read(Providers.nakamaClientProvider);
    final nakamaSessionAsync =
        ref.read(Providers.nakamaSessionAsyncNotifierProvider);

    if (nakamaSessionAsync.hasValue && nakamaSessionAsync.value != null) {
      state = const AsyncLoading();

      final session = nakamaSessionAsync.value!;

      final leaderboardRecordList = await nakamaClient.listLeaderboardRecords(
        leaderboardName: leaderboardName,
        session: session,
      );

      final leaderboardRecords = leaderboardRecordList.records;

      return leaderboardRecords;
    }

    throw Exception('No session available.');
  }

  Future<void> listLeaderboardRecords(int limit) async {
    final nakamaClient = ref.read(Providers.nakamaClientProvider);
    final nakamaSessionAsync =
        ref.read(Providers.nakamaSessionAsyncNotifierProvider);

    if (nakamaSessionAsync.hasValue && nakamaSessionAsync.value != null) {
      state = const AsyncLoading();

      final session = nakamaSessionAsync.value!;
      try {
        LeaderboardRecordList leaderboardRecordList =
            await nakamaClient.listLeaderboardRecords(
          leaderboardName: leaderboardName,
          session: session,
        );

        List<LeaderboardRecord> leaderboardRecords =
            leaderboardRecordList.records;

        state = AsyncData(leaderboardRecords);
      } catch (e) {
        state = AsyncError(e, StackTrace.current);
      }
    }

    throw Exception('No session available.');
  }

  Future<void> writeLeaderboardRecord({
    required int score,
  }) async {
    try {
      final nakamaClient = ref.read(Providers.nakamaClientProvider);
      final nakamaSessionAsync =
          ref.read(Providers.nakamaSessionAsyncNotifierProvider);

      if (nakamaSessionAsync.hasValue && nakamaSessionAsync.value != null) {
        final session = nakamaSessionAsync.value!;

        await nakamaClient.writeLeaderboardRecord(
          session: session,
          leaderboardName: leaderboardName,
          score: score,
        );
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
