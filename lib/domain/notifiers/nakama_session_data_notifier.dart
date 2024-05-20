import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gift_grab/data/services/hive_session_service.dart';
import 'package:gift_grab/domain/models/session_data_model.dart';
import 'package:gift_grab/domain/providers.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

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

    // Return session data from decoded token.
    return SessionData(
      uid: res['uid'],
      username: res['usn'],
      email: res['vrs']['email'],
      expiresAt: DateTime.fromMillisecondsSinceEpoch(res['exp'] * 1000),
    );
  }
}
