import 'package:bloc/bloc.dart';
import 'package:gift_grab/data/services/nakama_session_service.dart';
import 'package:gift_grab/data/services/social_auth_service.dart';
import 'package:gift_grab/presentation/services/event_handler_service.dart';
import 'package:nakama/nakama.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final NakamaSessionService _nakamaSessionService;
  final SocialAuthService _socialAuthService;

  AuthBloc(
      {NakamaSessionService? nakamaSessionService,
      SocialAuthService? socialAuthService})
      : _nakamaSessionService = nakamaSessionService ?? NakamaSessionService(),
        _socialAuthService = socialAuthService ?? SocialAuthService(),
        super(const AuthState()) {
    on<Logout>(
      (event, emit) async =>
          await EventHandlerService.handleBlocEvent<AuthState>(
        action: () async {
          if (!event.isDelete) {
            await _nakamaSessionService.logout();
          }
          emit(state.copyWith(authenticated: false));
        },
        emit: emit,
        errorState: (message) => state.copyWith(error: message),
      ),
    );
    on<LoginEmail>(
      (event, emit) async =>
          await EventHandlerService.handleBlocEvent<AuthState>(
        action: () async {
          emit(state.copyWith(isLoading: true));

          final session = await getNakamaClient().authenticateEmail(
            email: event.email,
            password: event.password,
          );

          await _nakamaSessionService.saveSessionTokens(session);

          emit(state.copyWith(authenticated: true));
        },
        emit: emit,
        errorState: (message) => state.copyWith(error: message),
      ),
    );
    on<SignUpEmail>(
      (event, emit) async =>
          await EventHandlerService.handleBlocEvent<AuthState>(
        action: () async {
          final session = await getNakamaClient().authenticateEmail(
            email: event.email,
            password: event.password,
            username: event.username,
            create: true,
          );

          await _nakamaSessionService.saveSessionTokens(session);

          emit(state.copyWith(authenticated: true));
        },
        emit: emit,
        errorState: (message) => state.copyWith(error: message),
      ),
    );
    on<CheckAuthStatus>(
      (event, emit) async =>
          await EventHandlerService.handleBlocEvent<AuthState>(
        action: () async {
          final session = await _nakamaSessionService.getValidSession();
          emit(state.copyWith(authenticated: session != null));
        },
        emit: emit,
        errorState: (message) => state.copyWith(error: message),
      ),
    );
    on<LoginGoogle>(
      (event, emit) async =>
          await EventHandlerService.handleBlocEvent<AuthState>(
        action: () async {
          final idToken = await _socialAuthService.getGoogleToken();

          if (idToken == null) {
            throw Exception('Failed to get Google authentication.');
          }

          final session = await getNakamaClient().authenticateGoogle(
            token: idToken,
          );

          await _nakamaSessionService.saveSessionTokens(session);

          emit(state.copyWith(authenticated: true));
        },
        emit: emit,
        errorState: (message) => state.copyWith(error: message),
      ),
    );
    on<LoginApple>(
      (event, emit) async =>
          await EventHandlerService.handleBlocEvent<AuthState>(
        action: () async {
          final idToken = await _socialAuthService.getAppleToken();

          if (idToken == null) {
            throw Exception('Failed to get Apple authentication.');
          }

          final session = await getNakamaClient().authenticateApple(
            token: idToken,
          );

          await _nakamaSessionService.saveSessionTokens(session);

          emit(state.copyWith(authenticated: true));
        },
        emit: emit,
        errorState: (message) => state.copyWith(error: message),
      ),
    );
  }
}
