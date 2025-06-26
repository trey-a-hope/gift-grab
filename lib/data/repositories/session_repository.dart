// data/repositories/session_repository_impl.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gift_grab/domain/repositories/i_session_repository.dart';
import 'package:nakama/nakama.dart';

class SessionRepository implements ISessionRepository {
  static const _tokenKey = 'nakama_token';
  static const _refreshTokenKey = 'nakama_refresh_token';

  final FlutterSecureStorage storage;
  final NakamaBaseClient nakamaClient;

  SessionRepository(
    this.storage,
    this.nakamaClient,
  );

  @override
  Future<Session?> getStoredSession() async {
    final token = await storage.read(key: _tokenKey);
    final refreshToken = await storage.read(key: _refreshTokenKey);

    if (token == null || refreshToken == null) return null;

    return Session.restore(
      token: token,
      refreshToken: refreshToken,
    );
  }

  @override
  Future<void> saveSession(Session session) async {
    await Future.wait([
      storage.write(key: _tokenKey, value: session.token),
      storage.write(key: _refreshTokenKey, value: session.refreshToken),
    ]);
  }

  @override
  Future<void> clearSession() async {
    try {
      await Future.wait([
        storage.delete(key: _tokenKey),
        storage.delete(key: _refreshTokenKey),
      ]);
    } catch (e) {
      throw Exception('Failed to clear tokens: $e');
    }
  }

  @override
  Future<Session> refreshSession(Session session) async {
    try {
      return await nakamaClient.sessionRefresh(session: session);
    } catch (e) {
      throw Exception('Failed to refresh session: $e');
    }
  }

  @override
  Future<void> logoutSession(Session session) async {
    try {
      await nakamaClient.sessionLogout(session: session);
    } catch (e) {
      throw Exception('Failed to logout session: $e');
    }
  }
}
