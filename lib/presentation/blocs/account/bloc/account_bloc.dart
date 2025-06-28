import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:gift_grab/domain/services/session_service.dart';
import 'package:gift_grab/domain/services/social_auth_service.dart';
import 'package:gift_grab/presentation/utils/bloc_handler.dart';
import 'package:nakama/nakama.dart';

part 'account_event.dart';
part 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final SessionService sessionService;
  final SocialAuthService socialAuthService;
  final NakamaBaseClient nakamaBaseClient;

  AccountBloc(
    this.sessionService,
    this.socialAuthService,
    this.nakamaBaseClient,
  ) : super(const AccountState()) {
    on<ReadAccount>(_onReadAccount);
    on<UpdateAccount>(_onUpdateAccount);
    on<DeleteAccount>(_onDeleteAccount);
    on<LinkEmailAccount>(_onLinkEmailAccount);
    on<UnlinkEmailAccount>(_onUnlinkEmailAccount);
    on<LinkGoogleAccount>(_onLinkGoogleAccount);
    on<UnlinkGoogleAccount>(_onUnlinkGoogleAccount);
    on<LinkAppleAccount>(_onLinkAppleAccount);
    on<UnlinkAppleAccount>(_onUnlinkAppleAccount);
  }

  void _onReadAccount(
    ReadAccount event,
    Emitter<AccountState> emit,
  ) async =>
      await BlocHandler<AccountState>().handle(
        action: () async {
          final session = await sessionService.getSession();

          final account = await nakamaBaseClient.getAccount(session);

          emit(
            state.copyWith(
              account: account,
              status: FormzSubmissionStatus.initial,
            ),
          );
        },
        emit: emit,
        state: state,
      );

  void _onUpdateAccount(
    UpdateAccount event,
    Emitter<AccountState> emit,
  ) async =>
      await BlocHandler<AccountState>().handle(
          action: () async {
            emit(state.copyWith(isLoading: true));

            final session = await sessionService.getSession();

            await nakamaBaseClient.updateAccount(
              session: session,
              username: event.username,
            );

            final updatedAccount = await nakamaBaseClient.getAccount(
              session,
            );

            emit(state.copyWith(
              success: 'Username updated successfully.',
              account: updatedAccount,
            ));
          },
          emit: emit,
          state: state);

  void _onDeleteAccount(
    DeleteAccount event,
    Emitter<AccountState> emit,
  ) async =>
      await BlocHandler<AccountState>().handle(
        action: () async {
          emit(state.copyWith(isLoading: true));

          final session = await sessionService.getSession();

          await nakamaBaseClient.rpc(
            session: session,
            id: 'account_delete_id',
          );
          sessionService.logout();
        },
        emit: emit,
        state: state,
      );

  void _onLinkEmailAccount(
    LinkEmailAccount event,
    Emitter<AccountState> emit,
  ) async =>
      await BlocHandler<AccountState>().handle(
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
              success: 'Email account linked successfully.',
            ),
          );
        },
        emit: emit,
        state: state,
      );

  void _onUnlinkEmailAccount(
    UnlinkEmailAccount event,
    Emitter<AccountState> emit,
  ) async =>
      await BlocHandler<AccountState>().handle(
        action: () async {
          emit(state.copyWith(isLoading: true));

          final session = await sessionService.getSession();
          final email = state.account?.email;

          if (email == null) {
            throw Exception('Email is null...');
          }

          await nakamaBaseClient.unlinkEmail(
            session: session,
            email: email,
            password: '', //Note, password is not required to unlink email.
          );

          emit(state.copyWith(
            success: 'Email account unlinked successfully.',
          ));
        },
        emit: emit,
        state: state,
      );

  void _onLinkGoogleAccount(
    LinkGoogleAccount event,
    Emitter<AccountState> emit,
  ) async =>
      await BlocHandler<AccountState>().handle(
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
            success: 'Google account linked successfully.',
          ));
        },
        emit: emit,
        state: state,
      );

  void _onUnlinkGoogleAccount(
    UnlinkGoogleAccount event,
    Emitter<AccountState> emit,
  ) async =>
      await BlocHandler<AccountState>().handle(
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
            success: 'Google account unlinked successfully.',
          ));
        },
        emit: emit,
        state: state,
      );

  void _onLinkAppleAccount(
    LinkAppleAccount event,
    Emitter<AccountState> emit,
  ) async =>
      await BlocHandler<AccountState>().handle(
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
            success: 'Apple account linked successfully.',
          ));
        },
        emit: emit,
        state: state,
      );

  void _onUnlinkAppleAccount(
    UnlinkAppleAccount event,
    Emitter<AccountState> emit,
  ) async =>
      await BlocHandler<AccountState>().handle(
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
            success: 'Apple account unlinked successfully.',
          ));
        },
        emit: emit,
        state: state,
      );
}
