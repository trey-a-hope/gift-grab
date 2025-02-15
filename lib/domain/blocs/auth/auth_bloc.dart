import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gift_grab/data/services/nakama_service.dart';
import 'package:gift_grab/data/services/social_auth_service.dart';
import 'package:gift_grab/data/services/web_socket_service.dart';
import 'package:grpc/grpc.dart';
import 'package:nakama/nakama.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  static const _storage = FlutterSecureStorage();
  static const _token = 'token';
  static const _refreshToken = 'refreshToken';

  final SocialAuthService _socialAuthService;
  final WebSocketService _webSocketService;
  final NakamaService _nakamaService;

  final inOneHour = DateTime.now().add(Duration(hours: 1));

  AuthBloc()
      : _socialAuthService = SocialAuthService(),
        _webSocketService = WebSocketService(),
        _nakamaService = NakamaService(),
        super(AuthInitial()) {
    on<LoginEmail>(_onLoginEmail);
    on<LoginGoogle>(_onLoginGoogle);
    on<LoginApple>(_onLoginApple);
    on<SignUpEmail>(_onSignUpEmail);
    on<Logout>(_onLogout);
    on<CheckAuthStatus>(_onCheckAuthStatus);
  }

  Future<void> _onLoginEmail(
    LoginEmail event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final session = await getNakamaClient().authenticateEmail(
        email: event.email,
        password: event.password,
      );

      debugPrint('Welcome back user ${session.userId}');

      await _storage.write(key: _token, value: session.token);
      await _storage.write(key: _refreshToken, value: session.refreshToken);

      emit(Authenticated());
    } on GrpcError catch (e) {
      emit(
        AuthError(message: e.message ?? 'Unknown GRPC Error: ${e.codeName}'),
      );
    } catch (e) {
      emit(AuthError(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  Future<void> _onLoginGoogle(
    LoginGoogle event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final idToken = await _socialAuthService.getGoogleToken();
      if (idToken == null) {
        throw Exception('Failed to get Google authentication.');
      }

      final session =
          await getNakamaClient().authenticateGoogle(token: idToken);

      debugPrint('Welcome back user ${session.userId}');

      await _storage.write(key: _token, value: session.token);
      await _storage.write(key: _refreshToken, value: session.refreshToken);

      emit(Authenticated());
    } on GrpcError catch (e) {
      emit(
        AuthError(message: e.message ?? 'Unknown GRPC Error: ${e.codeName}'),
      );
    } catch (e) {
      emit(AuthError(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  Future<void> _onLoginApple(
    LoginApple event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final idToken = await _socialAuthService.getAppleToken();
      if (idToken == null) {
        throw Exception('Failed to get Google authentication.');
      }

      final session = await getNakamaClient().authenticateApple(
        token: idToken,
      );

      debugPrint('Welcome back user ${session.userId}');

      await _storage.write(key: _token, value: session.token);
      await _storage.write(key: _refreshToken, value: session.refreshToken);

      emit(Authenticated());
    } on GrpcError catch (e) {
      emit(
        AuthError(message: e.message ?? 'Unknown GRPC Error: ${e.codeName}'),
      );
    } catch (e) {
      emit(AuthError(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  Future<void> _onSignUpEmail(
    SignUpEmail event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final session = await getNakamaClient().authenticateEmail(
        email: event.email,
        password: event.password,
        username: event.username,
        create: true,
      );

      debugPrint(
        'Session Token: ${session.token}, Refresh Token: ${session.refreshToken}',
      );
      await _storage.write(key: _token, value: session.token);
      await _storage.write(key: _refreshToken, value: session.refreshToken);

      emit(Authenticated());
    } on GrpcError catch (e) {
      emit(
        AuthError(message: e.message ?? 'Unknown GRPC Error: ${e.codeName}'),
      );
    } catch (e) {
      emit(AuthError(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  Future<void> _onLogout(
    Logout event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final session = await _nakamaService.getValidSession();

      if (session != null) {
        await getNakamaClient().sessionLogout(session: session);
      }

      await _storage.delete(key: _token);
      await _storage.delete(key: _refreshToken);

      _webSocketService.dispose();

      emit(Unauthenticated());
    } on GrpcError catch (e) {
      emit(
        AuthError(message: e.message ?? 'Unknown GRPC Error: ${e.codeName}'),
      );
    } catch (e) {
      emit(AuthError(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      await NakamaService().getValidSessionOrLogout(this);
      emit(Authenticated());
    } catch (e) {
      emit(Unauthenticated());
    }
  }
}
