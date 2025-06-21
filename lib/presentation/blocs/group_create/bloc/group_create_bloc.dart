import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:gift_grab/data/services/nakama_session_service.dart';
import 'package:gift_grab/presentation/blocs/auth/bloc/auth_bloc.dart';
import 'package:gift_grab/presentation/formz_inputs/comment.dart';
import 'package:gift_grab/presentation/formz_inputs/name.dart';
import 'package:gift_grab/presentation/formz_inputs/slider.dart';
import 'package:gift_grab/presentation/services/event_handler_service.dart';
import 'package:nakama/nakama.dart';

part 'group_create_event.dart';
part 'group_create_state.dart';

class GroupCreateBloc extends Bloc<GroupCreateEvent, GroupCreateState> {
  final AuthBloc authBloc;
  final NakamaSessionService _nakamaSessionService;

  GroupCreateBloc(
    this.authBloc, {
    NakamaSessionService? nakamaSessionService,
  })  : _nakamaSessionService = nakamaSessionService ?? NakamaSessionService(),
        super(GroupCreateState()) {
    on<NameChanged>(_onNameChanged);
    on<DescriptionChanged>(_onDescriptionChanged);
    on<MaxCountChanged>(_onMaxCountChanged);

    on<CreateGroup>(_onCreateGroup);
  }

  void _onNameChanged(
    NameChanged event,
    Emitter<GroupCreateState> emit,
  ) =>
      emit(
        state.copyWith(
          name: Name.dirty(event.name),
          status: FormzSubmissionStatus.initial,
        ),
      );

  void _onDescriptionChanged(
    DescriptionChanged event,
    Emitter<GroupCreateState> emit,
  ) =>
      emit(
        state.copyWith(
          description: Comment.dirty(event.description),
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
            open: true,
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
}
