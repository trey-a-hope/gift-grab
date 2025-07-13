import 'dart:async';

import 'package:gift_grab/domain/entities/auth_state.dart';
import 'package:gift_grab/domain/repositories/i_auth_stream_repository.dart';
import 'package:gift_grab/domain/services/session_service.dart';
import 'package:gift_grab/domain/services/social_auth_service.dart';
import 'package:nakama/nakama.dart';

class AuthStreamRepository implements IAuthStreamRepository {
  final NakamaBaseClient nakamaClient;
  final SessionService sessionService;
  final SocialAuthService socialAuthService;

  AuthStreamRepository(
    this.nakamaClient,
    this.sessionService,
    this.socialAuthService,
  );

  final StreamController<AuthState> _authStateController =
      StreamController<AuthState>.broadcast();

  void _updateState(AuthState newState) {
    _currentState = newState;
    _authStateController.add(newState);
  }

  @override
  AuthState get currentState => _currentState;
  AuthState _currentState = const AuthState();

  @override
  Stream<AuthState> get authStateStream => _authStateController.stream;

  @override
  void dispose() {
    _authStateController.close();
  }

  @override
  Future<void> loginEmail(String email, String password) async {
    try {
      final session = await nakamaClient.authenticateEmail(
        email: email,
        password: password,
      );

      await sessionService.saveSessionTokens(session);

      final newState = _currentState.copyWith(authenticated: true);
      _updateState(newState);
    } catch (e) {
      final newState = _currentState.copyWith(
        authenticated: false,
        error: e.toString(),
      );
      _updateState(newState);
    }
  }

  @override
  Future<void> logout() async {
    try {
      await sessionService.logout();

      final newState = _currentState.copyWith(authenticated: false);
      _updateState(newState);
    } catch (e) {
      final newState = _currentState.copyWith(error: e.toString());
      _updateState(newState);
    }
  }

  @override
  Future<void> checkAuthStatus() async {
    try {
      final session = await sessionService.getStoredSession();

      if (session == null) {
        final newState = _currentState.copyWith(authenticated: false);
        _updateState(newState);
      } else {
        if (sessionService.shouldRefreshSession(session)) {
          await sessionService.refreshSession(session);
        }

        final newState = _currentState.copyWith(authenticated: true);
        _updateState(newState);
      }
    } catch (e) {
      final newState = _currentState.copyWith(error: e.toString());
      _updateState(newState);
    }
  }

  @override
  Future<void> signup(String email, String password, String username) async {
    try {
      final session = await getNakamaClient().authenticateEmail(
        email: email,
        password: password,
        username: username,
        create: true,
      );

      await sessionService.saveSessionTokens(session);

      final newState = _currentState.copyWith(authenticated: true);
      _updateState(newState);
    } catch (e) {
      final newState = _currentState.copyWith(error: e.toString());
      _updateState(newState);
    }
  }

  @override
  Future<void> loginGoogle() async {
    try {
      final idToken = await socialAuthService.getGoogleToken();

      if (idToken == null) {
        throw Exception('Failed to get Google authentication.');
      }

      final session =
          await getNakamaClient().authenticateGoogle(token: idToken);
      await sessionService.saveSessionTokens(session);

      final newState = _currentState.copyWith(authenticated: true);
      _updateState(newState);
    } catch (e) {
      final newState = _currentState.copyWith(error: e.toString());
      _updateState(newState);
    }
  }

  @override
  Future<void> loginApple() async {
    try {
      final idToken = await socialAuthService.getAppleToken();

      if (idToken == null) {
        throw Exception('Failed to get Apple authentication.');
      }

      final session = await getNakamaClient().authenticateApple(token: idToken);
      await sessionService.saveSessionTokens(session);

      final newState = _currentState.copyWith(authenticated: true);
      _updateState(newState);
    } catch (e) {
      final newState = _currentState.copyWith(error: e.toString());
      _updateState(newState);
    }
  }
}
