import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:gift_grab/data/services/nakama_session_service.dart';
import 'package:gift_grab/presentation/blocs/account/bloc/account_bloc.dart';
import 'package:gift_grab/presentation/blocs/auth/auth.dart';
import 'package:gift_grab/presentation/formz_inputs/name.dart';

part 'edit_profile_event.dart';
part 'edit_profile_state.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  final AuthBloc authBloc;
  final AccountBloc accountBloc;
  final NakamaSessionService _nakamaSessionService;

  EditProfileBloc(
    this.authBloc,
    this.accountBloc, {
    NakamaSessionService? nakamaSessionService,
  })  : _nakamaSessionService = nakamaSessionService ?? NakamaSessionService(),
        super(EditProfileState()) {
    on<Init>(_onInit);
    on<UsernameChanged>(_onUsernameChanged);
    on<SaveForm>(_onSaveForm);

    add(Init());
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
        username: Name.dirty(account.user.username ?? ''),
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
          username: Name.dirty(event.name),
          status: FormzSubmissionStatus.initial,
        ),
      );

  void _onSaveForm(
    SaveForm event,
    Emitter<EditProfileState> emit,
  ) async {
    final _ = (await _nakamaSessionService.getValidSession(
      requireValid: true,
      authBloc: authBloc,
    ))!;

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
