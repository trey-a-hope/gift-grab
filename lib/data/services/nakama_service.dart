import 'package:flutter/material.dart';
import 'package:nakama/nakama.dart';

enum NakamaAuthMethod {
  email,
  device,
}

class NakamaService {
  NakamaAuth auth = NakamaAuth();
  NakamaLeaderboards leaderboards = NakamaLeaderboards();

  static const String _host = '127.0.0.1';
  static const bool _ssl = false;
  static const String _defaultkey = 'defaultkey';

  NakamaService() {
    // Set the Namaka client.
    getNakamaClient(
      host: _host,
      ssl: _ssl,
      serverKey: _defaultkey,
    );
  }
}

class NakamaAuth {
  Future<Session> createUserViaEmail({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      Session session = await getNakamaClient().authenticateEmail(
        email: email,
        password: password,
        username: username,
        create: true,
      );

      debugPrint('Nakama UID: ${session.userId}');

      return session;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<Session> authUserViaEmail({
    required String email,
    required String password,
  }) async {
    try {
      Session session = await getNakamaClient().authenticateEmail(
        email: email,
        password: password,
        create: false,
      );

      debugPrint('Nakama UID: ${session.userId}');

      return session;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<Session> createUserViaDevice({
    required String deviceId,
    required String username,
  }) async {
    try {
      Session session = await getNakamaClient().authenticateDevice(
        deviceId: deviceId,
        username: username,
        create: true,
      );

      debugPrint('Nakama UID: ${session.userId}');

      return session;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<Session> authUserViaDevice({
    required String deviceId,
  }) async {
    try {
      Session session = await getNakamaClient().authenticateDevice(
        deviceId: deviceId,
        create: false,
      );

      debugPrint('Nakama UID: ${session.userId}');

      return session;
    } catch (e) {
      throw Exception(e);
    }
  }
}

class NakamaLeaderboards {
  static const String _leaderboardName = 'top_gift_scores';

  Future<LeaderboardRecord> writeLeaderboardRecord({
    required Session session,
    required int score,
  }) async {
    try {
      LeaderboardRecord leaderboardRecord =
          await getNakamaClient().writeLeaderboardRecord(
        session: session,
        leaderboardName: _leaderboardName,
        score: score,
      );

      debugPrint('Leaderboard ID: ${leaderboardRecord.leaderboardId}');

      return leaderboardRecord;
    } catch (e) {
      throw Exception(e);
    }
  }
}
