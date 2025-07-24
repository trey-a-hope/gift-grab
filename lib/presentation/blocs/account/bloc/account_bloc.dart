import 'package:bloc_error_handler/bloc_error_handler.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:gift_grab/data/enums/rcp_functions.dart';
import 'package:gift_grab/data/repositories/auth_stream_repository.dart';
import 'package:gift_grab/domain/services/session_service.dart';
import 'package:gift_grab/domain/services/social_auth_service.dart';
import 'package:nakama/nakama.dart';

part 'account_event.dart';
part 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final SessionService sessionService;
  final NakamaBaseClient nakamaBaseClient;
  final AuthStreamRepository authStreamRepository;
  final SocialAuthService socialAuthService;

  AccountBloc(
    this.sessionService,
    this.nakamaBaseClient,
    this.authStreamRepository,
    this.socialAuthService,
  ) : super(const AccountState()) {
    on<ReadAccount>(_onReadAccount);
    on<UpdateAccount>(_onUpdateAccount);
    on<DeleteAccount>(_onDeleteAccount);
    on<LinkEmail>(_onLinkEmail);
    on<UnlinkEmail>(_onUnlinkEmail);
    on<LinkGoogle>(_onLinkGoogle);
    on<UnlinkGoogle>(_onUnlinkGoogle);
    on<LinkApple>(_onLinkApple);
    on<UnlinkApple>(_onUnlinkApple);
  }

  Future<void> _onReadAccount(
    ReadAccount event,
    Emitter<AccountState> emit,
  ) async =>
      await runWithErrorHandling<AccountState>(
        action: () async {
          emit(state.copyWith(isLoading: true));

          final session = await sessionService.getSession();

          final account = await nakamaBaseClient.getAccount(session);

          emit(state.copyWith(account: account));
        },
        emit: emit,
        state: state,
      );

  Future<void> _onUpdateAccount(
    UpdateAccount event,
    Emitter<AccountState> emit,
  ) async =>
      await runWithErrorHandling<AccountState>(
        action: () async {
          emit(state.copyWith(isLoading: true));

          final session = await sessionService.getSession();

          await nakamaBaseClient.updateAccount(
            session: session,
            username: event.username,
          );

          final updatedAccount = state.account!.copyWith(
            user: state.account!.user.copyWith(
              username: event.username,
            ),
          );

          emit(state.copyWith(
            success: Globals.feedbackMessages.accountUpdateSuccess,
            account: updatedAccount,
          ));
        },
        emit: emit,
        state: state,
      );

  Future<void> _onDeleteAccount(
    DeleteAccount event,
    Emitter<AccountState> emit,
  ) async =>
      await runWithErrorHandling<AccountState>(
        action: () async {
          emit(state.copyWith(isLoading: true));

          final session = await sessionService.getSession();

          await nakamaBaseClient.rpc(
            session: session,
            id: RPCFunction.AccountDelete.id,
          );

          await authStreamRepository.logout();

          emit(
            state.copyWith(
              success: Globals.feedbackMessages.accountDeleteSuccess,
              account: null,
            ),
          );
        },
        emit: emit,
        state: state,
      );

  Future<void> _onLinkEmail(
    LinkEmail event,
    Emitter<AccountState> emit,
  ) async =>
      await runWithErrorHandling(
        action: () async {
          emit(state.copyWith(isLoading: true));

          final session = await sessionService.getSession();

          await nakamaBaseClient.linkEmail(
            session: session,
            email: event.email,
            password: event.password,
          );

          emit(
            state.copyWith(
              success: Globals.feedbackMessages.accountLinkEmailSuccess,
            ),
          );
        },
        emit: emit,
        state: state,
      );

  Future<void> _onUnlinkEmail(
    UnlinkEmail event,
    Emitter<AccountState> emit,
  ) async =>
      await runWithErrorHandling(
        action: () async {
          emit(state.copyWith(isLoading: true));

          final session = await sessionService.getSession();

          final email = state.account?.email;

          if (email == null) {
            throw Exception(
              Globals.feedbackMessages.accountEmailNull,
            );
          }

          await nakamaBaseClient.unlinkEmail(
            session: session,
            email: email,
            password: '', //Note, password is required but can be empty
          );

          emit(state.copyWith(
              success: Globals.feedbackMessages.accountUnlinkEmailSuccess));
        },
        emit: emit,
        state: state,
      );

  Future<void> _onLinkGoogle(
    LinkGoogle event,
    Emitter<AccountState> emit,
  ) async =>
      await runWithErrorHandling(
        action: () async {
          emit(state.copyWith(isLoading: true));

          final session = await sessionService.getSession();

          final idToken = await socialAuthService.getGoogleToken();

          if (idToken == null) {
            emit(state.copyWith());
            return;
          }

          await nakamaBaseClient.linkGoogle(session: session, token: idToken);

          emit(state.copyWith(
            success: Globals.feedbackMessages.accountLinkGoogle,
          ));
        },
        emit: emit,
        state: state,
      );

  Future<void> _onUnlinkGoogle(
    UnlinkGoogle event,
    Emitter<AccountState> emit,
  ) async =>
      await runWithErrorHandling(
        action: () async {
          emit(state.copyWith(isLoading: true));

          final session = await sessionService.getSession();

          final idToken = await socialAuthService.getGoogleToken();

          if (idToken == null) {
            emit(state.copyWith());
            return;
          }

          await nakamaBaseClient.unlinkGoogle(session: session, token: idToken);

          emit(state.copyWith(
            success: Globals.feedbackMessages.accountUnlinkGoogle,
          ));
        },
        emit: emit,
        state: state,
      );

  Future<void> _onLinkApple(
    LinkApple event,
    Emitter<AccountState> emit,
  ) async =>
      await runWithErrorHandling(
        action: () async {
          emit(state.copyWith(isLoading: true));

          final session = await sessionService.getSession();

          final idToken = await socialAuthService.getAppleToken();

          if (idToken == null) {
            emit(state.copyWith());
            return;
          }

          await nakamaBaseClient.linkApple(session: session, token: idToken);

          emit(state.copyWith(
            success: Globals.feedbackMessages.accountLinkApple,
          ));
        },
        emit: emit,
        state: state,
      );

  Future<void> _onUnlinkApple(
    UnlinkApple event,
    Emitter<AccountState> emit,
  ) async =>
      await runWithErrorHandling(
        action: () async {
          emit(state.copyWith(isLoading: true));

          final session = await sessionService.getSession();

          final idToken = await socialAuthService.getAppleToken();

          if (idToken == null) {
            emit(state.copyWith());
            return;
          }

          await nakamaBaseClient.unlinkApple(session: session, token: idToken);

          emit(state.copyWith(
            success: Globals.feedbackMessages.accountUnlinkApple,
          ));
        },
        emit: emit,
        state: state,
      );
}
