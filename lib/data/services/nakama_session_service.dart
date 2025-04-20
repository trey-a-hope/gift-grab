import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gift_grab/presentation/blocs/auth/bloc/auth_bloc.dart';
import 'package:nakama/nakama.dart';

class NakamaSessionService {
  static const _tokenKey = 'nakama_token';
  static const _refreshTokenKey = 'nakama_refresh_token';
  static const _preemptiveRefreshDuration = Duration(hours: 1);

  final FlutterSecureStorage _storage;

  NakamaSessionService({
    FlutterSecureStorage? storage,
  }) : _storage = storage ?? const FlutterSecureStorage();

  Future<void> _clearTokens() async {
    try {
      await Future.wait([
        _storage.delete(key: _tokenKey),
        _storage.delete(key: _refreshTokenKey),
      ]);
    } catch (e) {
      throw Exception('Failed to clear tokens: $e');
    }
  }

  Future<Session?> _getStoredSession() async {
    final token = await _storage.read(key: _tokenKey);
    final refreshToken = await _storage.read(key: _refreshTokenKey);

    if (token == null || refreshToken == null) return null;

    final session = Session.restore(
      token: token,
      refreshToken: refreshToken,
    );

    if (session == null) {
      await _clearTokens();
      return null;
    }

    return session;
  }

  Future<void> saveSessionTokens(Session session) async {
    await Future.wait([
      _storage.write(key: _tokenKey, value: session.token),
      _storage.write(key: _refreshTokenKey, value: session.refreshToken),
    ]);
  }

  bool _shouldRefreshSession(Session session) =>
      session.isExpired ||
      session.hasExpired(
        DateTime.now().add(_preemptiveRefreshDuration),
      );

  Future<Session> _refreshSession(Session session) async {
    try {
      final newSession =
          await getNakamaClient().sessionRefresh(session: session);
      await saveSessionTokens(newSession);
      return newSession;
    } catch (e) {
      await _clearTokens();
      throw Exception('Failed to refresh session: $e');
    }
  }

  Future<Session?> getValidSession({
    bool requireValid = false,
    AuthBloc? authBloc,
  }) async {
    try {
      final session = await _getStoredSession();

      if (session == null) {
        if (authBloc != null) {
          authBloc.add(Logout());
        }

        if (requireValid) {
          throw Exception('No valid session available');
        }

        return null;
      }

      if (_shouldRefreshSession(session)) {
        return await _refreshSession(session);
      }

      return session;
    } catch (e) {
      await _clearTokens();
      if (requireValid) {
        throw Exception('Failed to get valid session: $e');
      }

      return null;
    }
  }

  Future<bool> logout() async {
    try {
      final session = await _getStoredSession();

      if (session != null) {
        try {
          await getNakamaClient().sessionLogout(session: session);
        } catch (e) {
          // Continue with local cleanup even if remote logout fails
        }
      }

      await _clearTokens();

      return true;
    } catch (e) {
      await _clearTokens();
      return false;
    }
  }
}
