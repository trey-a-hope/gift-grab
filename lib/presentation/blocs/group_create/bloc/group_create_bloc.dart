import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:gift_grab/data/services/nakama_session_service.dart';
import 'package:gift_grab/presentation/blocs/auth/bloc/auth_bloc.dart';
import 'package:gift_grab/presentation/formz_inputs/long_text/view.dart';
import 'package:gift_grab/presentation/formz_inputs/short_text/view.dart';
import 'package:gift_grab/presentation/formz_inputs/slider/slider.dart';
import 'package:gift_grab/presentation/formz_inputs/toggle/view.dart';
import 'package:gift_grab/presentation/services/event_handler_service.dart';
import 'package:nakama/nakama.dart';

part 'group_create_event.dart';
part 'group_create_state.dart';

class GroupCreateBloc extends Bloc<GroupCreateEvent, GroupCreateState> {
  final AuthBloc authBloc;
  final NakamaSessionService _nakamaSessionService;
  final Group? group;

  bool get isNew => group == null;

  GroupCreateBloc(
    this.authBloc, {
    NakamaSessionService? nakamaSessionService,
    this.group,
  })  : _nakamaSessionService = nakamaSessionService ?? NakamaSessionService(),
        super(GroupCreateState()) {
    on<Init>(_onInit);
    on<NameChanged>(_onNameChanged);
    on<DescriptionChanged>(_onDescriptionChanged);
    on<MaxCountChanged>(_onMaxCountChanged);
    on<IsOpenChanged>(_onIsOpenChanged);
    on<SubmitForm>(_onSubmitForm);
    on<CreateGroup>(_onCreateGroup);
    on<UpdateGroup>(_onUpdateGroup);

    add(Init());
  }

  void _onInit(
    Init event,
    Emitter<GroupCreateState> emit,
  ) {
    if (!isNew) {
      emit(
        state.copyWith(
          name: ShortText.dirty(group!.name ?? ''),
          description: LongText.dirty(group!.description ?? ''),
          maxCount: Slider.dirty(group!.maxCount!),
          isOpen: Toggle.dirty(group!.open!),
          status: FormzSubmissionStatus.initial,
        ),
      );
    }
  }

  void _onNameChanged(
    NameChanged event,
    Emitter<GroupCreateState> emit,
  ) =>
      emit(
        state.copyWith(
          name: ShortText.dirty(event.name),
          status: FormzSubmissionStatus.initial,
        ),
      );

  void _onDescriptionChanged(
    DescriptionChanged event,
    Emitter<GroupCreateState> emit,
  ) =>
      emit(
        state.copyWith(
          description: LongText.dirty(event.description),
          status: FormzSubmissionStatus.initial,
        ),
      );

  void _onMaxCountChanged(
    MaxCountChanged event,
    Emitter<GroupCreateState> emit,
  ) {
    emit(
      state.copyWith(
        maxCount: Slider.dirty(event.maxCount),
        status: FormzSubmissionStatus.initial,
      ),
    );
  }

  void _onIsOpenChanged(
    IsOpenChanged event,
    Emitter<GroupCreateState> emit,
  ) {
    emit(
      state.copyWith(
        isOpen: Toggle.dirty(event.isOpen),
        status: FormzSubmissionStatus.initial,
      ),
    );
  }

  Future<void> _onSubmitForm(
    SubmitForm event,
    Emitter<GroupCreateState> emit,
  ) async {
    if (isNew) {
      add(CreateGroup());
    } else {
      add(UpdateGroup());
    }
  }

  Future<void> _onCreateGroup(
    CreateGroup event,
    Emitter<GroupCreateState> emit,
  ) async =>
      await BlocHandler<GroupCreateState>().handle(
        action: () async {
          emit(
            state.copyWith(
              status: FormzSubmissionStatus.inProgress,
            ),
          );

          final session = (await _nakamaSessionService.getValidSession(
              requireValid: true, authBloc: authBloc))!;

          final newGroup = await getNakamaClient().createGroup(
            session: session,
            name: state.name.value,
            description: state.description.value,
            maxCount: state.maxCount.value,
            open: state.isOpen.value,
          );

          emit(
            state.copyWith(
              success: 'Group \'${newGroup.name ?? ''}\' created',
              status: FormzSubmissionStatus.success,
            ),
          );
        },
        emit: emit,
        state: state,
      );

  Future<void> _onUpdateGroup(
    UpdateGroup event,
    Emitter<GroupCreateState> emit,
  ) async =>
      await BlocHandler<GroupCreateState>().handle(
        action: () async {
          emit(
            state.copyWith(
              status: FormzSubmissionStatus.inProgress,
            ),
          );

          final session = (await _nakamaSessionService.getValidSession(
              requireValid: true, authBloc: authBloc))!;

          await getNakamaClient().updateGroup(
            groupId: group!.id,
            session: session,
            name: state.name.value,
            description: state.description.value,
            maxCount: state.maxCount.value,
            open: state.isOpen.value,
            langTag: 'en', //cannot be empty for some reason...
          );

          emit(
            state.copyWith(
              success: 'Group \'${state.name.value}\' updated',
              status: FormzSubmissionStatus.success,
            ),
          );
        },
        emit: emit,
        state: state,
      );
}
