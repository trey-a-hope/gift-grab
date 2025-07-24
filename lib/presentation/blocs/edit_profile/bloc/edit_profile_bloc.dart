import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:gift_grab/domain/services/session_service.dart';
import 'package:gift_grab/presentation/blocs/account/bloc/account_bloc.dart';
import 'package:gift_grab_ui/formz_inputs/short_text/short_text.dart';
import 'package:bloc_error_handler/bloc_error_handler.dart';

part 'edit_profile_event.dart';
part 'edit_profile_state.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  final AccountBloc accountBloc;
  final SessionService sessionService;

  EditProfileBloc(
    this.accountBloc,
    this.sessionService,
  ) : super(const EditProfileState()) {
    on<Init>(_onInit);
    on<UsernameChanged>(_onUsernameChanged);
    on<SaveForm>(_onSaveForm);
  }

  Future<void> _onInit(
    Init event,
    Emitter<EditProfileState> emit,
  ) async =>
      await runWithErrorHandling<EditProfileState>(
        action: () async {
          final account = accountBloc.state.account!;

          emit(
            state.copyWith(
              username: ShortText.dirty(account.user.username ?? ''),
              status: FormzSubmissionStatus.initial,
            ),
          );
        },
        emit: emit,
        state: state,
      );

  Future<void> _onUsernameChanged(
    UsernameChanged event,
    Emitter<EditProfileState> emit,
  ) async =>
      emit(state.copyWith(
        username: ShortText.dirty(event.name),
        status: FormzSubmissionStatus.initial,
      ));

  Future<void> _onSaveForm(
    SaveForm event,
    Emitter<EditProfileState> emit,
  ) async =>
      await runWithErrorHandling<EditProfileState>(
        action: () async {
          emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

          final _ = await sessionService.getSession();

          accountBloc.add(UpdateAccount(username: state.username.value));

          final completer = Completer<void>();
          StreamSubscription? subscription;

          try {
            subscription = accountBloc.stream.listen((accountState) {
              if (accountState.success != null) {
                emit(state.copyWith(status: FormzSubmissionStatus.success));
                completer.complete();
              }
              if (accountState.error != null) {
                emit(state.copyWith(status: FormzSubmissionStatus.failure));
                completer.complete();
              }
            });

            await Future.any([
              completer.future,
              Future.delayed(Globals.durations.streamListenSeconds)
            ]);

            if (!completer.isCompleted) {
              emit(state.copyWith(status: FormzSubmissionStatus.failure));
            }
          } finally {
            subscription?.cancel();
          }
        },
        emit: emit,
        state: state,
      );
}
