import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_grab/data/services/nakama_service.dart';
import 'package:gift_grab/domain/blocs/auth/auth_bloc.dart';
import 'package:grpc/grpc.dart';
import 'package:nakama/nakama.dart';

part 'account_event.dart';
part 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final AuthBloc authBloc;

  AccountBloc({required this.authBloc}) : super(AccountInitial()) {
    on<FetchAccount>(_onFetchAccount);
    on<UpdateAccount>(_onUpdateAccount);
    on<DeleteAccount>(_onDeleteAccount);
  }

  Future<void> _onFetchAccount(
    FetchAccount event,
    Emitter<AccountState> emit,
  ) async {
    emit(AccountLoading());

    try {
      final session = await NakamaService().getValidSession();

      if (session == null) {
        authBloc.add(Logout());
        return;
      }

      debugPrint(session.toString());
      final account = await getNakamaClient().getAccount(session);
      emit(AccountLoaded(account: account));
    } catch (e) {
      if (e is GrpcError) {
        switch (e.codeName) {
          case 'NOT_FOUND':
            emit(AccountError(
                message: 'Account not found. Please check your credentials.'));
          case 'INVALID_ARGUMENT':
            emit(AccountError(message: 'Invalid email or password.'));
          case 'UNAUTHENTICATED':
            emit(AccountError(message: 'Auth token invalid.'));
          default:
            emit(AccountError(message: 'Authentication failed: ${e.message}'));
        }
      } else {
        emit(AccountError(message: e.toString()));
      }
    }
  }

  Future<void> _onUpdateAccount(
    UpdateAccount event,
    Emitter<AccountState> emit,
  ) async {
    emit(AccountLoading());

    try {
      final session = await NakamaService().getValidSession();

      if (session == null) {
        authBloc.add(Logout());
        return;
      }

      await getNakamaClient().updateAccount(
        session: session,
        username: event.username,
      );

      emit(AccountActionSuccess(message: 'Username updated successfully.'));
    } catch (e) {
      if (e is GrpcError) {
        switch (e.codeName) {
          case 'INVALID_ARGUMENT':
            emit(AccountError(message: 'Username is already in use.'));
          default:
            emit(AccountError(message: 'Update failed: ${e.message}'));
        }
      } else {
        emit(AccountError(message: e.toString()));
      }
    }
  }

  Future<void> _onDeleteAccount(
    DeleteAccount event,
    Emitter<AccountState> emit,
  ) async {
    emit(AccountLoading());

    try {
      final session = await NakamaService().getValidSession();

      if (session == null) {
        authBloc.add(Logout());
        return;
      }

      await getNakamaClient().rpc(session: session, id: 'account_delete_id');
      await NakamaService().clearTokens();
      authBloc.add(Logout());
    } catch (e) {
      emit(AccountError(message: e.toString()));
    }
  }
}
