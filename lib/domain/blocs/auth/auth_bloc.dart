import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gift_grab/data/services/nakama_service.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:grpc/grpc.dart';
import 'package:nakama/nakama.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  static const _storage = FlutterSecureStorage();
  static const _token = 'token';
  static const _refreshToken = 'refreshToken';

  final inOneHour = DateTime.now().add(Duration(hours: 1));

  AuthBloc() : super(AuthInitial()) {
    on<LoginEmail>(_onLoginEmail);
    on<LoginGoogle>(_onLoginGoogle);
    on<SignUp>(_onSignUp);
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

      debugPrint(
        'Session Token: ${session.token}, Refresh Token: ${session.refreshToken}',
      );
      await _storage.write(key: _token, value: session.token);
      await _storage.write(key: _refreshToken, value: session.refreshToken);

      emit(Authenticated());
    } catch (e) {
      if (e is GrpcError) {
        switch (e.codeName) {
          case 'NOT_FOUND':
            emit(AuthError(
                message: 'Account not found. Please check your credentials.'));
          case 'INVALID_ARGUMENT':
            emit(AuthError(message: 'Invalid email or password.'));
          case 'UNAUTHENTICATED':
            emit(AuthError(message: 'Invalid credentials.'));
          default:
            emit(AuthError(message: 'Authentication failed: ${e.message}'));
        }
      } else {
        emit(AuthError(message: e.toString()));
      }
    }
  }

  Future<void> _onLoginGoogle(
    LoginGoogle event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      const List<String> scopes = <String>[
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ];

      final googleSignIn = GoogleSignIn(
        clientId:
            '955072082839-oo9gainsq9d4scss7kjuttqt5u54vshj.apps.googleusercontent.com',
        scopes: scopes,
      );

      final res = await googleSignIn.signIn();

      if (res == null) throw Exception('res is null');

      debugPrint(res.toString());

      final googleAuth = await res.authentication;
      final idToken = googleAuth.idToken;
      if (idToken == null) throw Exception('ID token is null');

      final session =
          await getNakamaClient().authenticateGoogle(token: idToken);

      debugPrint(
        'Session Token: ${session.token}, Refresh Token: ${session.refreshToken}',
      );

      await _storage.write(key: _token, value: session.token);
      await _storage.write(key: _refreshToken, value: session.refreshToken);

      emit(Authenticated());
    } catch (e) {
      if (e is GrpcError) {
        switch (e.codeName) {
          case 'NOT_FOUND':
            emit(AuthError(
                message: 'Account not found. Please check your credentials.'));
          case 'INVALID_ARGUMENT':
            emit(AuthError(message: 'Invalid email or password.'));
          case 'UNAUTHENTICATED':
            emit(AuthError(message: 'Invalid credentials.'));
          default:
            emit(AuthError(message: 'Authentication failed: ${e.message}'));
        }
      } else {
        emit(AuthError(message: e.toString()));
      }
    }
  }

  Future<void> _onSignUp(
    SignUp event,
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
    } catch (e) {
      if (e is GrpcError) {
        switch (e.codeName) {
          case 'INVALID_ARGUMENT':
            emit(AuthError(message: 'Invalid email or password.'));
          case 'UNAUTHENTICATED':
            emit(AuthError(message: 'Invalid credentials.'));
          default:
            emit(AuthError(message: 'Authentication failed: ${e.message}'));
        }
      } else {
        emit(AuthError(message: e.toString()));
      }
    }
  }

  Future<void> _onLogout(
    Logout event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      await _storage.delete(key: _token);
      await _storage.delete(key: _refreshToken);

      emit(Unauthenticated());
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
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
