import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:gift_grab/data/services/social_auth_service.dart';
import 'package:gift_grab/domain/services/session_service.dart';
import 'package:nakama/nakama.dart';

class AuthStreamRepository {
  final NakamaBaseClient nakamaClient;
  final SessionService sessionService;
  final SocialAuthService socialAuthService;

  AuthStreamRepository(
    this.nakamaClient,
    this.sessionService,
    this.socialAuthService,
  );

  final StreamController<_AuthState> _authStateController =
      StreamController<_AuthState>.broadcast();

  _AuthState get currentState => _currentState;
  _AuthState _currentState = const _AuthState();

  Stream<_AuthState> get authStateStream => _authStateController.stream;

  void _updateState(_AuthState newState) {
    _currentState = newState;
    _authStateController.add(newState);
  }

  Future<void> loginEmail(String email, String password) async {
    try {
      final session = await nakamaClient.authenticateEmail(
        email: email,
        password: password,
      );

      await sessionService.saveSessionTokens(session);

      final newState = _currentState.copyWith(
        authenticated: true,
      );

      _updateState(newState);
    } catch (e) {
      final newState = _currentState.copyWith(
        authenticated: false,
        error: e.toString(),
      );

      _updateState(newState);
    }
  }

  Future<void> signup(String email, String password, String username) async {
    try {
      final session = await getNakamaClient().authenticateEmail(
        email: email,
        password: password,
        username: username,
        create: true,
      );

      await sessionService.saveSessionTokens(session);

      final newState = _currentState.copyWith(
        authenticated: true,
      );

      _updateState(newState);
    } catch (e) {
      final newState = _currentState.copyWith(
        error: e.toString(),
      );

      _updateState(newState);
    }
  }

  Future<void> logout() async {
    try {
      final _ = await sessionService.logout();

      final newState = _currentState.copyWith(
        authenticated: false,
      );

      _updateState(newState);
    } catch (e) {
      final newState = _currentState.copyWith(
        error: e.toString(),
      );

      _updateState(newState);
    }
  }

  Future<void> checkAuthStatus() async {
    try {
      final session = await sessionService.getStoredSession();

      if (session == null) {
        final newState = _currentState.copyWith(
          authenticated: false,
        );

        _updateState(newState);
      } else {
        if (sessionService.shouldRefreshSession(session)) {
          await sessionService.refreshSession(session);
        }

        final newState = _currentState.copyWith(
          authenticated: true,
        );

        _updateState(newState);
      }
    } catch (e) {
      final newState = _currentState.copyWith(
        error: e.toString(),
      );

      _updateState(newState);
    }
  }

  Future<void> loginGoogle() async {
    try {
      final idToken = await socialAuthService.getGoogleToken();

      if (idToken == null) {
        throw Exception('Failed to get Google authentication.');
      }

      final session = await getNakamaClient().authenticateGoogle(
        token: idToken,
      );

      await sessionService.saveSessionTokens(session);

      final newState = _currentState.copyWith(
        authenticated: true,
      );

      _updateState(newState);
    } catch (e) {
      final newState = _currentState.copyWith(
        error: e.toString(),
      );

      _updateState(newState);
    }
  }

  Future<void> loginApple() async {
    try {
      final idToken = await socialAuthService.getAppleToken();

      if (idToken == null) {
        throw Exception('Failed to get Apple authentication.');
      }

      final session = await getNakamaClient().authenticateApple(
        token: idToken,
      );

      await sessionService.saveSessionTokens(session);

      final newState = _currentState.copyWith(
        authenticated: true,
      );

      _updateState(newState);
    } catch (e) {
      final newState = _currentState.copyWith(
        error: e.toString(),
      );

      _updateState(newState);
    }
  }

  void dispose() {
    _authStateController.close();
  }
}

class _AuthState extends Equatable {
  final bool authenticated;
  final String? error;

  const _AuthState({
    this.authenticated = false,
    this.error,
  });

  _AuthState copyWith({
    bool? authenticated,
    String? error,
  }) =>
      _AuthState(
        authenticated: authenticated ?? this.authenticated,
        error: error,
      );

  @override
  List<Object?> get props => [
        authenticated,
        error,
      ];
}
