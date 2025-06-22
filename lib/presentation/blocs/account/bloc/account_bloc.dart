import 'package:bloc/bloc.dart';
import 'package:formz/formz.dart';
import 'package:gift_grab/data/services/nakama_session_service.dart';
import 'package:gift_grab/data/services/social_auth_service.dart';
import 'package:gift_grab/presentation/blocs/auth/bloc/auth_bloc.dart';
import 'package:gift_grab/presentation/formz_inputs/name.dart';
import 'package:gift_grab/presentation/services/event_handler_service.dart';
import 'package:nakama/nakama.dart';

part 'account_event.dart';
part 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final AuthBloc authBloc;
  final NakamaSessionService _nakamaSessionService;
  final SocialAuthService _socialAuthService;

  AccountBloc(this.authBloc,
      {NakamaSessionService? nakamaSessionService,
      SocialAuthService? socialAuthService})
      : _nakamaSessionService = nakamaSessionService ?? NakamaSessionService(),
        _socialAuthService = socialAuthService ?? SocialAuthService(),
        super(const AccountState()) {
    on<ReadAccount>(
      (event, emit) async =>
          await EventHandlerService.handleBlocEvent<AccountState>(
        action: () async {
          // emit(state.copyWith(isLoading: true));

          final session = (await _nakamaSessionService.getValidSession(
            requireValid: true,
            authBloc: authBloc,
          ))!;

          final account = await getNakamaClient().getAccount(session);

          emit(
            state.copyWith(
              account: account,
              currentUsername: Name.dirty(account.user.username!),
              status: FormzSubmissionStatus.initial,
            ),
          );
        },
        emit: emit,
        errorState: (message) => state.copyWith(error: message),
      ),
    );
    on<UpdateAccount>(
      (event, emit) async =>
          await EventHandlerService.handleBlocEvent<AccountState>(
        action: () async {
          emit(state.copyWith(isLoading: true));

          final session = (await _nakamaSessionService.getValidSession(
            requireValid: true,
            authBloc: authBloc,
          ))!;

          if (state.currentUsername == state.account?.user.username) {
            throw Exception('New name required');
          }

          await getNakamaClient().updateAccount(
            session: session,
            username: event.username,
          );

          final updatedAccount = await getNakamaClient().getAccount(
            session,
          );

          emit(state.copyWith(
            success: 'Username updated successfully.',
            account: updatedAccount,
          ));
        },
        emit: emit,
        errorState: (message) => state.copyWith(error: message),
      ),
    );
    on<DeleteAccount>(
      (event, emit) async =>
          await EventHandlerService.handleBlocEvent<AccountState>(
        action: () async {
          emit(state.copyWith(isLoading: true));

          final session = (await _nakamaSessionService.getValidSession(
            requireValid: true,
            authBloc: authBloc,
          ))!;

          await getNakamaClient().rpc(
            session: session,
            id: 'account_delete_id',
          );

          authBloc.add(Logout(isDelete: true));
        },
        emit: emit,
        errorState: (message) => state.copyWith(error: message),
      ),
    );
    on<LinkEmailAccount>(
      (event, emit) async =>
          await EventHandlerService.handleBlocEvent<AccountState>(
        action: () async {
          emit(state.copyWith(isLoading: true));

          final session = (await _nakamaSessionService.getValidSession(
            requireValid: true,
            authBloc: authBloc,
          ))!;

          await getNakamaClient().linkEmail(
            session: session,
            email: event.email,
            password: event.password,
          );

          emit(
            state.copyWith(
              success: 'Email account linked successfully.',
            ),
          );
        },
        emit: emit,
        errorState: (message) => state.copyWith(error: message),
      ),
    );
    on<UnlinkEmailAccount>(
      (event, emit) async =>
          await EventHandlerService.handleBlocEvent<AccountState>(
        action: () async {
          emit(state.copyWith(isLoading: true));

          final session = (await _nakamaSessionService.getValidSession(
            requireValid: true,
            authBloc: authBloc,
          ))!;
          final email = state.account?.email;

          if (email == null) {
            throw Exception('Email is null...');
          }

          await getNakamaClient().unlinkEmail(
            session: session,
            email: email,
            password: '', //Note, password is not required to unlink email.
          );

          emit(state.copyWith(
            success: 'Email account unlinked successfully.',
          ));
        },
        emit: emit,
        errorState: (message) => state.copyWith(error: message),
      ),
    );
    on<LinkGoogleAccount>(
      (event, emit) async =>
          await EventHandlerService.handleBlocEvent<AccountState>(
        action: () async {
          emit(state.copyWith(isLoading: true));

          final session = (await _nakamaSessionService.getValidSession(
            requireValid: true,
            authBloc: authBloc,
          ))!;

          final idToken = await _socialAuthService.getGoogleToken();

          if (idToken == null) {
            emit(state.copyWith());
            return;
          }

          await getNakamaClient().linkGoogle(session: session, token: idToken);

          emit(state.copyWith(
            success: 'Google account linked successfully.',
          ));
        },
        emit: emit,
        errorState: (message) => state.copyWith(error: message),
      ),
    );
    on<UnlinkGoogleAccount>(
      (event, emit) async =>
          await EventHandlerService.handleBlocEvent<AccountState>(
        action: () async {
          emit(state.copyWith(isLoading: true));

          final session = (await _nakamaSessionService.getValidSession(
            requireValid: true,
            authBloc: authBloc,
          ))!;

          final idToken = await _socialAuthService.getGoogleToken();

          if (idToken == null) {
            emit(state.copyWith());
            return;
          }

          await getNakamaClient()
              .unlinkGoogle(session: session, token: idToken);

          emit(state.copyWith(
            success: 'Google account unlinked successfully.',
          ));
        },
        emit: emit,
        errorState: (message) => state.copyWith(error: message),
      ),
    );
    on<LinkAppleAccount>(
      (event, emit) async =>
          await EventHandlerService.handleBlocEvent<AccountState>(
        action: () async {
          emit(state.copyWith(isLoading: true));

          final session = (await _nakamaSessionService.getValidSession(
            requireValid: true,
            authBloc: authBloc,
          ))!;

          final idToken = await _socialAuthService.getAppleToken();

          if (idToken == null) {
            emit(state.copyWith());
            return;
          }

          await getNakamaClient().linkApple(session: session, token: idToken);

          emit(state.copyWith(
            success: 'Apple account linked successfully.',
          ));
        },
        emit: emit,
        errorState: (message) => state.copyWith(error: message),
      ),
    );
    on<UnlinkAppleAccount>(
      (event, emit) async =>
          await EventHandlerService.handleBlocEvent<AccountState>(
        action: () async {
          emit(state.copyWith(isLoading: true));

          final session = (await _nakamaSessionService.getValidSession(
            requireValid: true,
            authBloc: authBloc,
          ))!;

          final idToken = await _socialAuthService.getAppleToken();

          if (idToken == null) {
            emit(state.copyWith());
            return;
          }

          await getNakamaClient().unlinkApple(session: session, token: idToken);

          emit(state.copyWith(
            success: 'Apple account unlinked successfully.',
          ));
        },
        emit: emit,
        errorState: (message) => state.copyWith(error: message),
      ),
    );
  }
}
