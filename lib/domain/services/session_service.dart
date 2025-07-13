import 'package:gift_grab/domain/repositories/i_session_repository.dart';
import 'package:nakama/nakama.dart';

class SessionService {
  static const _preemptiveRefreshDuration = Duration(hours: 1);

  final ISessionRepository _iSessionRepository;

  SessionService(this._iSessionRepository);

  Future<Session?> getStoredSession() async {
    return await _iSessionRepository.getStoredSession();
  }

  Future<void> saveSessionTokens(Session session) async {
    await _iSessionRepository.saveSession(session);
  }

  bool shouldRefreshSession(Session session) =>
      session.isExpired ||
      session.hasExpired(DateTime.now().add(_preemptiveRefreshDuration));

  Future<Session> refreshSession(Session session) async {
    try {
      final newSession = await _iSessionRepository.refreshSession(session);
      await _iSessionRepository.saveSession(newSession);
      return newSession;
    } catch (e) {
      await _iSessionRepository.clearSession();
      throw Exception('Failed to refresh session: $e');
    }
  }

  Future<Session> getSession() async {
    try {
      final session = await _iSessionRepository.getStoredSession();

      if (session == null) {
        throw Exception('No stored session.');
      }

      if (shouldRefreshSession(session)) {
        return await refreshSession(session);
      }

      return session;
    } catch (e) {
      await _iSessionRepository.clearSession();
      rethrow;
    }
  }

  Future<bool> logout() async {
    try {
      final session = await _iSessionRepository.getStoredSession();

      if (session != null) {
        try {
          await _iSessionRepository.logoutSession(session);
        } catch (e) {}
      }

      await _iSessionRepository.clearSession();
      return true;
    } catch (e) {
      await _iSessionRepository.clearSession();
      return false;
    }
  }
}
