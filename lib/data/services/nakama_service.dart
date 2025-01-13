import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gift_grab/domain/blocs/auth/auth_bloc.dart';
import 'package:nakama/nakama.dart';

class NakamaService {
  final _storage = const FlutterSecureStorage();

  Future<void> clearTokens() async {
    try {
      await _storage.delete(key: 'token');
      await _storage.delete(key: 'refreshToken');
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<Session?> getValidSessionOrLogout(AuthBloc authBloc) async {
    final session = await _getValidSession();
    if (session == null) {
      authBloc.add(Logout());
    }
    return session;
  }

  Future<Session?> _getValidSession() async {
    try {
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
        // Clear invalid tokens from storage
        await _storage.delete(key: 'token');
        await _storage.delete(key: 'refreshToken');
        return null;
      }

      // Check if session is expired or close to expiry
      if (session.isExpired ||
          session.hasExpired(DateTime.now().add(const Duration(hours: 1)))) {
        final client = getNakamaClient();
        final newSession = await client.sessionRefresh(session: session);

        // Save new tokens
        await Future.wait([
          _storage.write(key: 'token', value: newSession.token),
          _storage.write(key: 'refreshToken', value: newSession.refreshToken),
        ]);

        return newSession;
      }

      return session;
    } catch (e) {
      // Clear tokens on any error
      await Future.wait([
        _storage.delete(key: 'token'),
        _storage.delete(key: 'refreshToken'),
      ]);
      return null;
    }
  }
}
