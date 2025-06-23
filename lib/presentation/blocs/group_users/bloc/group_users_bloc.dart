import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_grab/data/services/nakama_session_service.dart';
import 'package:gift_grab/presentation/blocs/auth/bloc/auth_bloc.dart';
import 'package:gift_grab/presentation/services/event_handler_service.dart';
import 'package:nakama/nakama.dart';

part 'group_users_event.dart';
part 'group_users_state.dart';

class GroupUsersBloc extends Bloc<GroupUsersEvent, GroupUsersState> {
  final AuthBloc authBloc;
  final NakamaSessionService _nakamaSessionService;
  final String groupId;

  GroupUsersBloc(
    this.authBloc, {
    required this.groupId,
    NakamaSessionService? nakamaSessionService,
  })  : _nakamaSessionService = nakamaSessionService ?? NakamaSessionService(),
        super(GroupUsersState()) {
    on<ListGroupUsers>(_onListGroupUsers);

    add(ListGroupUsers());
  }

  Future<void> _onListGroupUsers(
    ListGroupUsers event,
    Emitter<GroupUsersState> emit,
  ) async =>
      await BlocHandler<GroupUsersState>().handle(
        action: () async {
          final session = (await _nakamaSessionService.getValidSession(
              requireValid: true, authBloc: authBloc))!;

          // TODO: Add cursor.
          final groupUserList = await getNakamaClient().listGroupUsers(
            session: session,
            groupId: groupId,
          );

          emit(state.copyWith(groupUsers: groupUserList.groupUsers));
        },
        emit: emit,
        state: state,
      );
}
