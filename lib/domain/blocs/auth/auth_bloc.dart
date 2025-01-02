import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nakama/nakama.dart';

part 'auth_event.dart';
part 'auth_state.dart';

final _storage = const FlutterSecureStorage();
const _token = 'token';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<LoginEvent>(_handleLogin);
    on<LogoutEvent>(_handleLogout);
    on<CheckAuthStatusEvent>(_handleCheckAuthStatus);
  }

  Future<void> _handleLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    try {
      final session = await getNakamaClient().authenticateEmail(
        email: event.email,
        password: event.password,
      );

      debugPrint('Session Token: ${session.token}');
      await _storage.write(key: _token, value: session.token);

      emit(Authenticated(token: session.token));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _handleLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    try {
      await _storage.delete(key: _token);
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _handleCheckAuthStatus(
      CheckAuthStatusEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    try {
      String? token = await _storage.read(key: _token);

      if (token != null) {
        // TODO: Check if token expired...
        emit(Authenticated(token: token));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(Unauthenticated());
    }
  }
}
