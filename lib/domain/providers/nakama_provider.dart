import 'package:flutter/material.dart';
import 'package:gift_grab/data/services/nakama_service.dart';
import 'package:nakama/nakama.dart';

class NakamaProvider extends ChangeNotifier {
  final NakamaService _nakamaService = NakamaService();

  Session? _session;

  NakamaProvider() {
    debugPrint('NakamaProvider created.');
  }

  Future createUserViaEmail({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      // Create new user.
      Session session = await _nakamaService.auth.createUserViaEmail(
        email: email,
        password: password,
        username: username,
      );

      // Set session.
      _session = session;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future authUserViaEmail({
    required String email,
    required String password,
  }) async {
    try {
      // Authenticate user with email and password.
      Session session = await _nakamaService.auth.authUserViaEmail(
        email: email,
        password: password,
      );

      // Set session.
      _session = session;

      // notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future createUserViaDevice({
    required String deviceId,
    required String username,
  }) async {
    try {
      Session session = await _nakamaService.auth.authUserViaDevice(
        deviceId: deviceId,
      );

      // Set session.
      _session = session;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future authUserViaDevice({
    required String deviceId,
  }) async {
    try {
      Session session = await _nakamaService.auth.authUserViaDevice(
        deviceId: deviceId,
      );

      // Set session.
      _session = session;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<LeaderboardRecord> writeLeaderboardRecord({required int score}) async {
    try {
      if (_session == null) {
        throw Exception('Session has not started yet.');
      }

      // Save score to leaderboard.
      LeaderboardRecord leaderboardRecord =
          await _nakamaService.leaderboards.writeLeaderboardRecord(
        session: _session!,
        score: score,
      );

      return leaderboardRecord;
    } catch (e) {
      throw Exception(e);
    }
  }
}
