import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gift_grab/data/services/nakama_services.dart';
import 'package:gift_grab/domain/models/leaderboard_record/leaderboard_record_model.dart';
import 'package:gift_grab/domain/providers.dart';

class NakamaLeaderboardNotifier
    extends AsyncNotifier<List<LeaderboardRecordModel>> {
  final storage = const FlutterSecureStorage();

  String _nextCursor = '';
  late String? _token;

  bool get hasMore => _token != '';

  @override
  FutureOr<List<LeaderboardRecordModel>> build() async {
    try {
      await ref.read(Providers.nakamaAuthProvider.notifier).check();

      _token = (await storage.read(key: 'token'));

      if (_token == null) {
        throw Exception(
            'Token null, should not reach this point after check...');
      }

      final leaderboard = await NakamaServices.leaderboard
          .get(sessionToken: _token!, limit: 10);

      _nextCursor = leaderboard.nextCursor;

      debugPrint('Leaderboard: $leaderboard');

      return leaderboard.records;
    } catch (e) {
      throw Exception();
    }
  }

  void fetchMore() async {
    try {
      await ref.read(Providers.nakamaAuthProvider.notifier).check();

      final leaderboard = await NakamaServices.leaderboard.get(
        sessionToken: _token!,
        limit: 1,
        nextCursor: _nextCursor,
      );

      final currentRecords = state.value ?? [];

      state = AsyncData([...currentRecords, ...leaderboard.records]);
    } catch (e) {
      throw Exception(
        'Could not fetch more records at this time. ${e.toString()}',
      );
    }
  }
}

// import 'dart:async';
// import 'dart:convert';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:gift_grab/data/services/hive_session_service.dart';
// import 'package:gift_grab/domain/providers.dart';
// import 'package:nakama/nakama.dart';

// class NakamaLeaderboardNotifier extends AsyncNotifier<List<LeaderboardRecord>> {
//   /// Leaderboard name.
//   static const _leaderboardName = 'weekly_leaderboard';

//   // /// HiveSessionService instance.
//   // final _hiveSessionService = HiveSessionService();

//   @override
//   FutureOr<List<LeaderboardRecord>> build() async {
//     await ref.read(Providers.nakamaAuthProvider.notifier).check();

//     // Fetch the current session.
//     // final session = await _hiveSessionService.sessionActive();

//     // If session is null, return empty list.
//     // if (session == null) {
//     //   return [];
//     // }

//     // // Get leaderboard records.
//     // final leaderboardRecordList =
//     //     await getNakamaClient().listLeaderboardRecords(
//     //   session: session,
//     //   leaderboardName: _leaderboardName,
//     // );

//     // // Return leaderboard records from list.
//     // return leaderboardRecordList.records ?? [];
//     throw UnimplementedError();
//   }

//   /// Write leaderboard record.
//   Future writeLeaderboardRecord({required int score}) async {
//     throw UnimplementedError();
//     // // Fetch the current session.
//     // final session = await _hiveSessionService.sessionActive();

//     // // If session is null, return.
//     // if (session == null) {
//     //   return;
//     // }

//     // // Write leaderboard record.
//     // await getNakamaClient().writeLeaderboardRecord(
//     //   session: session,
//     //   leaderboardName: _leaderboardName,
//     //   score: score,
//     //   metadata: jsonEncode(
//     //     {
//     //       'avatar': ref.read(Providers.selectedAvatarProvider)?.name,
//     //     },
//     //   ),
//     // );

//     // // Get leaderboard records.
//     // final leaderboardRecordList =
//     //     await getNakamaClient().listLeaderboardRecords(
//     //   session: session,
//     //   leaderboardName: _leaderboardName,
//     // );

//     // // Update state with new records.
//     // state = AsyncData(leaderboardRecordList.records ?? []);
//   }
// }
