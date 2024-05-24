import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gift_grab/data/services/hive_session_service.dart';
import 'package:nakama/nakama.dart';

class NakamaUsersNotifier extends AsyncNotifier<List<User>> {
  /// HiveSessionService instance.
  final _hiveSessionService = HiveSessionService();

  // TODO: Determine if these users should be saved to this provider.
  @override
  FutureOr<List<User>> build() => [];

  Future<User> getUser({required String uid}) async {
    // Fetch the current session.
    final session = await _hiveSessionService.sessionActive();

    if (session == null) {
      throw Exception('Could not fetch session...');
    }

    final users =
        await getNakamaClient().getUsers(session: session, ids: [uid]);

    return users.first;
  }
}
