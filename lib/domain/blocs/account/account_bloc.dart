import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_grab/data/services/nakama_service.dart';
import 'package:gift_grab/domain/blocs/auth/auth_bloc.dart';
import 'package:nakama/nakama.dart';

part 'account_event.dart';
part 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final AuthBloc authBloc;
  AccountBloc({required this.authBloc}) : super(AccountInitial()) {
    on<FetchAccountEvent>(_onFetchAccount);
    on<UpdateAccountEvent>(_onUpdateAccount);
    on<DeleteAccountEvent>(_onDeleteAccount);
  }

  Future<void> _onFetchAccount(
    FetchAccountEvent event,
    Emitter<AccountState> emit,
  ) async {
    emit(AccountLoading());

    try {
      final session = await NakamaService().getValidSession();

      if (session == null) {
        throw Exception('Session expired...');
      } else {
        final account = await getNakamaClient().getAccount(session);
        emit(AccountLoaded(account: account));
      }
    } catch (e) {
      emit(AccountError(message: e.toString()));
    }
  }

  Future<void> _onUpdateAccount(
    UpdateAccountEvent event,
    Emitter<AccountState> emit,
  ) async {
    emit(AccountLoading());

    try {
      final session = await NakamaService().getValidSession();

      if (session == null) {
        throw Exception('Session expired...');
      } else {
        await getNakamaClient().updateAccount(
          session: session,
          username: event.username,
        );
        add(FetchAccountEvent());
      }
    } catch (e) {
      emit(AccountError(message: e.toString()));
    }
  }

  Future<void> _onDeleteAccount(
    DeleteAccountEvent event,
    Emitter<AccountState> emit,
  ) async {
    emit(AccountLoading());

    try {
      final session = await NakamaService().getValidSession();

      if (session == null) {
        throw Exception('Session expired...');
      } else {
        await getNakamaClient().rpc(session: session, id: 'account_delete_id');

        await NakamaService().clearTokens();

        authBloc.add(CheckAuthStatusEvent());
      }
    } catch (e) {
      emit(AccountError(message: e.toString()));
    }
  }
}
