import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nakama/nakama.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  static const _storage = FlutterSecureStorage();
  static const _token = 'token';
  static const _refreshToken = 'refreshToken';
  final inOneHour = DateTime.now().add(Duration(hours: 1));

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

  Future<void> _handleLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    try {
      await _storage.delete(key: _token);
      await _storage.delete(key: _refreshToken);

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
      String? refreshToken = await _storage.read(key: _refreshToken);

      if (token != null && refreshToken != null) {
        var session = Session.restore(
          token: token,
          refreshToken: refreshToken,
        );

        if (session == null) {
          emit(Unauthenticated());
        }

        // Check whether a session has expired or is close to expiry.
        if (session!.isExpired || session.hasExpired(inOneHour)) {
          try {
            // Attempt to refresh the existing session.
            session = await getNakamaClient().sessionRefresh(session: session);

            debugPrint('Refreshed!');
            debugPrint(
              'Session Token: ${session.token}, Refresh Token: ${session.refreshToken}',
            );

            await _storage.write(key: _token, value: session.token);
            await _storage.write(
                key: _refreshToken, value: session.refreshToken);
            emit(Authenticated());
          } catch (e) {
            emit(Unauthenticated());
          }
        } else {
          emit(Authenticated());
        }
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(Unauthenticated());
    }
  }
}
