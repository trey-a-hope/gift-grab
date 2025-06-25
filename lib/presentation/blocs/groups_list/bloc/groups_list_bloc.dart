import 'package:bloc/bloc.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:gift_grab/data/services/nakama_session_service.dart';
import 'package:gift_grab/presentation/extensions/list_user_group_extensions.dart';
import 'package:gift_grab/presentation/services/event_handler_service.dart';
import 'package:nakama/nakama.dart';

part 'groups_list_event.dart';
part 'groups_list_state.dart';

class GroupsListBloc extends Bloc<GroupsListEvent, GroupsListState> {
  final bool all;
  final NakamaSessionService _nakamaSessionService;
  GroupsListBloc({
    required this.all,
    NakamaSessionService? nakamaSessionService,
  })  : _nakamaSessionService = nakamaSessionService ?? NakamaSessionService(),
        super(GroupsListState(all)) {
    on<ListGroups>(_onListGroups);
  }

  Future<void> _onListGroups(
    ListGroups event,
    Emitter<GroupsListState> emit,
  ) async =>
      await BlocHandler<GroupsListState>().handle(
        action: () async {
          emit(state.copyWith(isLoading: true));

          final session = (await _nakamaSessionService.getSession());

          String? uid = all ? null : session.userId;

          final res = await _fetchGroups(session, clearCursor: false, uid: uid);

          final curGroups = event.clearCursor ? <Group>[] : state.groups;

          emit(state
              .copyWith(groups: [...curGroups, ...res.$2], cursor: res.$1));
        },
        emit: emit,
        state: state,
      );

  Future<(String? newCursor, List<Group> newGroups)> _fetchGroups(
    Session session, {
    required bool clearCursor,
    String? uid,
  }) async {
    final cursor = clearCursor ? null : state.cursor;

    late List<Group> newGroups;
    late String? newCursor;

    // All groups.
    if (uid == null) {
      final groupList = await getNakamaClient().listGroups(
        session: session,
        limit: Globals.paginationLimit,
        cursor: cursor,
      );

      newCursor = groupList.cursor == '' ? null : groupList.cursor;
      newGroups = groupList.groups ?? [];
    } else {
      final userGroupList = await getNakamaClient().listUserGroups(
        session: session,
        limit: Globals.paginationLimit,
        cursor: cursor,
        userId: uid,
      );

      newCursor = userGroupList.cursor == '' ? null : userGroupList.cursor;
      newGroups = userGroupList.userGroups?.toGroups() ?? [];
    }

    return (newCursor, newGroups);
  }
}
