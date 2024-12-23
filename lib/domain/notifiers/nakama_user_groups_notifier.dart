import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gift_grab/data/services/hive_session_service.dart';
import 'package:gift_grab/domain/providers.dart';
import 'package:nakama/nakama.dart';

class NakamaUserGroupsNotifier
    extends AutoDisposeFamilyAsyncNotifier<List<UserGroup>, String> {
  /// HiveSessionService instance.
  final _hiveSessionService = HiveSessionService();

  @override
  FutureOr<List<UserGroup>> build(String userId) async {
    ref.watch(Providers.nakamaGroupsProvider);
    // Fetch the current session.
    final session = await _hiveSessionService.sessionActive();

    // If session is null, return empty list.
    if (session == null) {
      return [];
    }

    final userGroupList = await getNakamaClient().listUserGroups(
      session: session,
      userId: userId,
    );

    return userGroupList.userGroups ?? [];
  }
}
