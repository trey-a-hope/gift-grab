import 'package:flutter/material.dart';
import 'package:gift_grab/data/services/nakama_service.dart';
import 'package:nakama/nakama.dart';

class NakamaProvider extends ChangeNotifier {
  final NakamaService _nakamaService = NakamaService();

  NakamaProvider() {
    debugPrint('Nakama Provider created.');
  }

  Future createEmail({
    required String email,
    required String password,
    required String username,
  }) async {
    await _nakamaService.auth.createEmail(
      email: email,
      password: password,
      username: username,
    );
  }

  Future<LeaderboardRecord> writeLeaderboardRecord({
    required int score,
  }) async {
    LeaderboardRecord leaderboardRecord =
        await _nakamaService.leaderboard.writeLeaderboardRecord(
      score: score,
    );

    return leaderboardRecord;
  }

  Future<List<LeaderboardRecord>> listLeaderboardRecords(int limit) async {
    List<LeaderboardRecord> leaderboardRecords =
        await _nakamaService.leaderboard.listLeaderboardRecords(
      20,
    );

    return leaderboardRecords;
  }
}
