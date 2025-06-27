import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:gift_grab/domain/services/session_service.dart';
import 'package:gift_grab/presentation/blocs/account/bloc/account_bloc.dart';
import 'package:gift_grab/presentation/formz_inputs/short_text/view.dart';

part 'edit_profile_event.dart';
part 'edit_profile_state.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  final AccountBloc accountBloc;
  final SessionService sessionService;

  EditProfileBloc(
    this.accountBloc,
    this.sessionService,
  ) : super(EditProfileState()) {
    on<Init>(_onInit);
    on<UsernameChanged>(_onUsernameChanged);
    on<SaveForm>(_onSaveForm);
  }

  void _onInit(
    Init event,
    Emitter<EditProfileState> emit,
  ) {
    final account = accountBloc.state.account;

    if (account == null) {
      throw Exception('Account is null');
    }

    emit(
      state.copyWith(
        username: ShortText.dirty(account.user.username ?? ''),
        status: FormzSubmissionStatus.initial,
      ),
    );
  }

  void _onUsernameChanged(
    UsernameChanged event,
    Emitter<EditProfileState> emit,
  ) =>
      emit(
        state.copyWith(
          username: ShortText.dirty(event.name),
          status: FormzSubmissionStatus.initial,
        ),
      );

  void _onSaveForm(
    SaveForm event,
    Emitter<EditProfileState> emit,
  ) async {
    final _ = (await sessionService.getSession());

    accountBloc.add(UpdateAccount(username: state.username.value));

    await for (final accountState in accountBloc.stream) {
      if (accountState.success != null) {
        emit(
          state.copyWith(status: FormzSubmissionStatus.success),
        );
        break;
      }
      if (accountState.error != null) {
        emit(state.copyWith(status: FormzSubmissionStatus.success));
        break;
      }
    }
  }
}
