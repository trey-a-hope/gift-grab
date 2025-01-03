import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gift_grab/data/services/nakama_service.dart';
import 'package:nakama/nakama.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  static const _storage = FlutterSecureStorage();
  static const _token = 'token';
  static const _refreshToken = 'refreshToken';
  final inOneHour = DateTime.now().add(Duration(hours: 1));

  AuthBloc() : super(AuthInitial()) {
    on<LoginEvent>(_onLoginEvent);
    on<SignUpEvent>(_onSignUpEvent);
    on<LogoutEvent>(_onLogoutEvent);
    on<CheckAuthStatusEvent>(_onCheckAuthStatusEvent);
  }

  Future<void> _onLoginEvent(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    try {
      final session = await getNakamaClient().authenticateEmail(
        email: event.email,
        password: event.password,
      );

      debugPrint(
        'Session Token: ${session.token}, Refresh Token: ${session.refreshToken}',
      );
      await _storage.write(key: _token, value: session.token);
      await _storage.write(key: _refreshToken, value: session.refreshToken);

      emit(Authenticated());
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onSignUpEvent(
      SignUpEvent event, Emitter<AuthState> emit) async {
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
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onLogoutEvent(
      LogoutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    try {
      await _storage.delete(key: _token);
      await _storage.delete(key: _refreshToken);

      emit(Unauthenticated());
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onCheckAuthStatusEvent(
      CheckAuthStatusEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    try {
      final session = await NakamaService().getValidSession();

      if (session == null) {
        emit(Unauthenticated());
      } else {
        emit(Authenticated());
      }
    } catch (e) {
      emit(Unauthenticated());
    }
  }
}
