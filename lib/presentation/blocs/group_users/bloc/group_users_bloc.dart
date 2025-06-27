import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_grab/domain/services/session_service.dart';
import 'package:gift_grab_ui/bloc_handler.dart';
import 'package:nakama/nakama.dart';

part 'group_users_event.dart';
part 'group_users_state.dart';

class GroupUsersBloc extends Bloc<GroupUsersEvent, GroupUsersState> {
  final SessionService sessionService;
  final String groupId;

  GroupUsersBloc(
    this.sessionService, {
    required this.groupId,
  }) : super(GroupUsersState()) {
    on<ListGroupUsers>(_onListGroupUsers);

    add(ListGroupUsers());
  }

  Future<void> _onListGroupUsers(
    ListGroupUsers event,
    Emitter<GroupUsersState> emit,
  ) async =>
      await BlocHandler<GroupUsersState>().handle(
        action: () async {
          final session = await sessionService.getSession();

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
