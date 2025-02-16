import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:gift_grab/data/services/nakama_service.dart';
import 'package:gift_grab/data/services/profanity_service.dart';
import 'package:gift_grab/data/services/social_auth_service.dart';
import 'package:gift_grab/domain/blocs/auth/auth_bloc.dart';
import 'package:grpc/grpc.dart';
import 'package:nakama/nakama.dart';

part 'account_event.dart';
part 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final AuthBloc authBloc;
  final SocialAuthService _socialAuthService;
  final NakamaService _nakamaService;
  final ProfanityService _profanityService;

  AccountBloc({
    required this.authBloc,
  })  : _socialAuthService = SocialAuthService(),
        _nakamaService = NakamaService(),
        _profanityService = ProfanityService(),
        super(AccountInitial(null)) {
    on<FetchAccount>(_onFetchAccount);
    on<SaveAccount>(_onSaveAccount);
    on<DeleteAccount>(_onDeleteAccount);
    on<LinkEmailAccount>(_onLinkEmailAccount);
    on<UnlinkEmailAccount>(_onUnlinkEmailAccount);
    on<LinkGoogleAccount>(_onLinkGoogleAccount);
    on<UnlinkGoogleAccount>(_onUnlinkGoogleAccount);
    on<LinkAppleAccount>(_onLinkAppleAccount);
    on<UnlinkAppleAccount>(_onUnlinkAppleAccount);
    on<UsernameChange>(_onUsernameChange);
  }

  Future<void> _onUsernameChange(
    UsernameChange event,
    Emitter<AccountState> emit,
  ) async {
    emit(
      AccountLoaded(
        account: state.account!,
        currentUsername: event.username,
      ),
    );
  }

  Future<void> _onFetchAccount(
    FetchAccount event,
    Emitter<AccountState> emit,
  ) async {
    emit(AccountLoading(state.account));

    try {
      final session = await _nakamaService.getValidSessionOrLogout(authBloc);

      final account = await getNakamaClient().getAccount(session);

      emit(
        AccountLoaded(
          account: account,
          currentUsername: account.user.username ?? 'No Username',
        ),
      );
    } on GrpcError catch (e) {
      emit(AccountError(
        message: e.message ?? 'Unknown GRPC Error: ${e.codeName}',
        account: state.account!,
      ));
    } catch (e) {
      emit(AccountError(
        message: 'Unexpected error: ${e.toString()}',
        account: state.account!,
      ));
    }
  }

  Future<void> _onSaveAccount(
    SaveAccount event,
    Emitter<AccountState> emit,
  ) async {
    emit(AccountLoading(state.account!));

    try {
      final session = await _nakamaService.getValidSessionOrLogout(authBloc);

      if (event.username == state.account?.user.username) {
        throw Exception('New name required');
      }

      await _profanityService.check(event.username);

      await getNakamaClient().updateAccount(
        session: session,
        username: event.username,
      );

      emit(AccountSuccess(
        message: 'Username updated successfully.',
        account: state.account!,
      ));
    } on GrpcError catch (e) {
      emit(AccountError(
        message: e.message ?? 'Unknown GRPC Error: ${e.codeName}',
        account: state.account!,
      ));
    } catch (e) {
      emit(AccountError(
        message: e.toString(),
        account: state.account!,
      ));
    }
  }

  Future<void> _onDeleteAccount(
    DeleteAccount event,
    Emitter<AccountState> emit,
  ) async {
    emit(AccountLoading(state.account!));

    try {
      final session = await _nakamaService.getValidSessionOrLogout(authBloc);

      await getNakamaClient().rpc(
        session: session,
        id: Globals.rpc.accountDeleteId,
      );

      await _nakamaService.clearTokens();

      authBloc.add(Logout());
    } on GrpcError catch (e) {
      emit(AccountError(
        message: e.message ?? 'Unknown GRPC Error: ${e.codeName}',
        account: state.account!,
      ));
    } catch (e) {
      emit(AccountError(
        message: 'Unexpected error: ${e.toString()}',
        account: state.account!,
      ));
    }
  }

  Future<void> _onLinkEmailAccount(
    LinkEmailAccount event,
    Emitter<AccountState> emit,
  ) async {
    emit(AccountLoading(state.account!));

    try {
      final session = await _nakamaService.getValidSessionOrLogout(authBloc);

      await getNakamaClient().linkEmail(
        session: session,
        email: event.email,
        password: event.password,
      );

      emit(
        AccountSuccess(
          message: 'Email account linked successfully.',
          account: state.account!,
        ),
      );
    } on GrpcError catch (e) {
      emit(AccountError(
        message: e.message ?? 'Unknown GRPC Error: ${e.codeName}',
        account: state.account!,
      ));
    } catch (e) {
      emit(AccountError(
        message: 'Unexpected error: ${e.toString()}',
        account: state.account!,
      ));
    }
  }

  Future<void> _onUnlinkEmailAccount(
    UnlinkEmailAccount event,
    Emitter<AccountState> emit,
  ) async {
    emit(AccountLoading(state.account!));

    try {
      final session = await _nakamaService.getValidSessionOrLogout(authBloc);

      final email = state.account?.email;

      if (email == null) {
        throw Exception('Email is null...');
      }

      await getNakamaClient().unlinkEmail(
        session: session,
        email: email,
        password: '', //Note, password is not required to unlink email.
      );

      emit(
        AccountSuccess(
          message: 'Email account unlinked successfully.',
          account: state.account!,
        ),
      );
    } on GrpcError catch (e) {
      emit(AccountError(
        message: e.message ?? 'Unknown GRPC Error: ${e.codeName}',
        account: state.account!,
      ));
    } catch (e) {
      emit(AccountError(
        message: 'Unexpected error: ${e.toString()}',
        account: state.account!,
      ));
    }
  }

  Future<void> _onLinkGoogleAccount(
    LinkGoogleAccount event,
    Emitter<AccountState> emit,
  ) async {
    emit(AccountLoading(state.account!));

    try {
      final session = await _nakamaService.getValidSessionOrLogout(authBloc);

      final idToken = await _socialAuthService.getGoogleToken();
      if (idToken == null) {
        throw Exception('Failed to get Google authentication.');
      }

      await getNakamaClient().linkGoogle(
        session: session,
        token: idToken,
      );

      emit(
        AccountSuccess(
          message: 'Google account linked successfully.',
          account: state.account!,
        ),
      );
    } on GrpcError catch (e) {
      emit(AccountError(
        message: e.message ?? 'Unknown GRPC Error: ${e.codeName}',
        account: state.account!,
      ));
    } catch (e) {
      emit(AccountError(
        message: 'Unexpected error: ${e.toString()}',
        account: state.account!,
      ));
    }
  }

  Future<void> _onUnlinkGoogleAccount(
    UnlinkGoogleAccount event,
    Emitter<AccountState> emit,
  ) async {
    emit(AccountLoading(state.account!));

    try {
      final session = await _nakamaService.getValidSessionOrLogout(authBloc);

      final idToken = await _socialAuthService.getGoogleToken();
      if (idToken == null) {
        throw Exception('Failed to get Google authentication.');
      }

      await getNakamaClient().unlinkGoogle(
        session: session,
        token: idToken,
      );

      emit(
        AccountSuccess(
          message: 'Google account unlinked successfully.',
          account: state.account!,
        ),
      );
    } on GrpcError catch (e) {
      emit(AccountError(
        message: e.message ?? 'Unknown GRPC Error: ${e.codeName}',
        account: state.account!,
      ));
    } catch (e) {
      emit(AccountError(
        message: 'Unexpected error: ${e.toString()}',
        account: state.account!,
      ));
    }
  }

  Future<void> _onLinkAppleAccount(
    LinkAppleAccount event,
    Emitter<AccountState> emit,
  ) async {
    emit(AccountLoading(state.account!));

    try {
      final session = await _nakamaService.getValidSessionOrLogout(authBloc);

      final idToken = await _socialAuthService.getAppleToken();
      if (idToken == null) {
        throw Exception('Failed to get Apple authentication.');
      }

      await getNakamaClient().linkApple(
        session: session,
        token: idToken,
      );

      emit(
        AccountSuccess(
          message: 'Apple account linked successfully.',
          account: state.account!,
        ),
      );
    } on GrpcError catch (e) {
      emit(AccountError(
        message: e.message ?? 'Unknown GRPC Error: ${e.codeName}',
        account: state.account!,
      ));
    } catch (e) {
      emit(AccountError(
        message: 'Unexpected error: ${e.toString()}',
        account: state.account!,
      ));
    }
  }

  Future<void> _onUnlinkAppleAccount(
    UnlinkAppleAccount event,
    Emitter<AccountState> emit,
  ) async {
    emit(AccountLoading(state.account!));

    try {
      final session = await _nakamaService.getValidSessionOrLogout(authBloc);

      final idToken = await _socialAuthService.getAppleToken();
      if (idToken == null) {
        throw Exception('Failed to get Apple authentication.');
      }

      await getNakamaClient().unlinkApple(
        session: session,
        token: idToken,
      );

      emit(
        AccountSuccess(
          message: 'Apple account unlinked successfully.',
          account: state.account!,
        ),
      );
    } on GrpcError catch (e) {
      emit(AccountError(
        message: e.message ?? 'Unknown GRPC Error: ${e.codeName}',
        account: state.account!,
      ));
    } catch (e) {
      emit(AccountError(
        message: 'Unexpected error: ${e.toString()}',
        account: state.account!,
      ));
    }
  }
}
