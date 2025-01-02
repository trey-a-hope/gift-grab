import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nakama/nakama.dart';

class NakamaService {
  final _storage = const FlutterSecureStorage();

  Future<Session?> getValidSession() async {
    final token = await _storage.read(key: 'token');
    final refreshToken = await _storage.read(key: 'refreshToken');

    if (token == null || refreshToken == null) {
      return null;
    }

    final session = Session.restore(
      token: token,
      refreshToken: refreshToken,
    );

    if (session == null) {
      return null;
    }

    // Check if session is expired or close to expiry
    if (session.isExpired ||
        session.hasExpired(DateTime.now().add(Duration(minutes: 5)))) {
      try {
        // Try to refresh the session
        final client = getNakamaClient();
        final newSession = await client.sessionRefresh(session: session);

        // Save new tokens
        await _storage.write(key: 'token', value: newSession.token);
        await _storage.write(
            key: 'refreshToken', value: newSession.refreshToken);

        return newSession;
      } catch (e) {
        return null;
        // throw Exception('Session expired and refresh failed');
      }
    }

    return session;
  }
}
