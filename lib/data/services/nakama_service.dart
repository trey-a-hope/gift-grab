import 'package:flutter/material.dart';
import 'package:nakama/api.dart';
import 'package:nakama/nakama.dart';
import 'package:nakama/src/session.dart' as ns;

late NakamaBaseClient _nakamaClient;

class NakamaService {
  NakamaAuth auth = NakamaAuth();
  NakamaLeaderboard leaderboard = NakamaLeaderboard();

  NakamaService() {
    _nakamaClient = getNakamaClient(
      host: '127.0.0.1',
      ssl: false,
      serverKey: 'defaultkey',
      httpPort: 7350,
    );

    debugPrint('Nakama Service created.');
  }
}

class NakamaAuth {
  Future<ns.Session> _authenticateEmail({
    required String email,
    required String password,
    required String? username,
    required bool create,
  }) async {
    try {
      ns.Session session = await _nakamaClient.authenticateEmail(
        email: email,
        password: password,
        username: username,
        create: create,
      );

      debugPrint('Nakama UID ${session.userId}');

      return session;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<ns.Session> createEmail({
    required String email,
    required String password,
    required String username,
  }) async {
    ns.Session session = await _authenticateEmail(
      email: email,
      password: password,
      username: username,
      create: true,
    );

    return session;
  }
}

class NakamaLeaderboard {
  static const String leaderboardId = 'weekly_leaderboard';

  Future<LeaderboardRecord> writeLeaderboardRecord({
    required ns.Session session,
    required int score,
  }) async {
    try {
      LeaderboardRecord leaderboardRecord =
          await _nakamaClient.writeLeaderboardRecord(
        session: session,
        leaderboardId: leaderboardId,
        score: score,
      );

      return leaderboardRecord;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<LeaderboardRecord>> listLeaderboardRecords({
    required ns.Session session,
  }) async {
    try {
      LeaderboardRecordList leaderboardRecordList =
          await _nakamaClient.listLeaderboardRecords(
        leaderboardName: leaderboardId,
        session: session,
      );

      List<LeaderboardRecord> leaderboardRecords =
          leaderboardRecordList.records;

      return leaderboardRecords;
    } catch (e) {
      throw Exception(e);
    }
  }
}
