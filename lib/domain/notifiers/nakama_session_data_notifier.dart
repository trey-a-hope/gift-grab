import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gift_grab/data/services/hive_session_service.dart';
import 'package:gift_grab/domain/models/session_data_model.dart';
import 'package:gift_grab/domain/providers.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:nakama/nakama.dart';

class NakamaSessionDataNotifier extends AsyncNotifier<SessionData?> {
  /// HiveSessionService instance.
  final _hiveSessionService = HiveSessionService();

  @override
  FutureOr<SessionData?> build() async {
    ref.watch(Providers.nakamaAuthProvider);

    // Fetch the current session.
    final session = await _hiveSessionService.sessionActive();

    if (session == null) {
      return null;
    }

    // Decode the session token.
    final res = JwtDecoder.decode(session.token);

    final account = await getNakamaClient().getAccount(session);

    // Return session data from decoded token.
    return SessionData(
      uid: res['uid'],
      username: res['usn'],
      email: res['vrs']['email'],
      expiresAt: DateTime.fromMillisecondsSinceEpoch(res['exp'] * 1000),
      avatarUrl: account.user.avatarUrl,
    );
  }

  Future updateUsername({required String newUsername}) async {
    // Fetch the current session.
    final session = await _hiveSessionService.sessionActive();

    if (session == null) {
      return null;
    }

    await getNakamaClient().updateAccount(
      session: session,
      username: newUsername,
    );

    final cur = state.valueOrNull;

    if (cur == null) return;

    state = AsyncData(
      SessionData(
        uid: cur.uid,
        email: cur.email,
        username: newUsername,
        expiresAt: cur.expiresAt,
      ),
    );
  }
}
