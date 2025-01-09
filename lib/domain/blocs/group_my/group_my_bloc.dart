import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:gift_grab/data/services/nakama_service.dart';
import 'package:gift_grab/domain/blocs/account/account_bloc.dart';
import 'package:gift_grab/domain/blocs/account/account_bloc_extension.dart';
import 'package:nakama/nakama.dart';

part 'group_my_event.dart';
part 'group_my_state.dart';

class GroupMyBloc extends Bloc<GroupMyEvent, GroupMyState> {
  final AccountBloc accountBloc;

  String? _cursor;

  GroupMyBloc({required this.accountBloc}) : super(GroupMyInitial()) {
    on<FetchGroups>(_onFetchGroups);
    on<FetchMoreGroups>(_onFetchMoreGroups);
    on<RefreshGroups>(_onRefreshGroups);
  }
  // New simple handler that just calls FetchGroups
  void _onRefreshGroups(RefreshGroups event, Emitter<GroupMyState> emit) async {
    add(FetchGroups());
  }

  Future<void> _onFetchGroups(
    FetchGroups event,
    Emitter<GroupMyState> emit,
  ) async {
    emit(GroupMyLoading());

    try {
      final session = await NakamaService().getValidSession();

      if (session == null) {
        throw Exception('Session expired...');
      } else {
        final myGroupsList = await getNakamaClient().listUserGroups(
          session: session,
          limit: Globals.paginationLimit,
          userId: accountBloc.uid,
        );

        _cursor = myGroupsList.cursor == '' ? null : myGroupsList.cursor;

        emit(
          GroupMyLoaded(
            groups: _userGroupsToGroups(myGroupsList.userGroups ?? []),
            hasMore: _cursor != null,
          ),
        );
      }
    } catch (e) {
      emit(GroupMyError(message: e.toString()));
    }
  }

  Future<void> _onFetchMoreGroups(
    FetchMoreGroups event,
    Emitter<GroupMyState> emit,
  ) async {
    try {
      final session = await NakamaService().getValidSession();

      if (session == null) {
        throw Exception('Session expired...');
      } else {
        final myGroupsList = await getNakamaClient().listUserGroups(
          session: session,
          limit: Globals.paginationLimit,
          userId: accountBloc.uid,
          cursor: _cursor,
        );

        _cursor = myGroupsList.cursor == '' ? null : myGroupsList.cursor;

        emit(
          GroupMyLoaded(
            groups: [
              ...event.groups,
              ..._userGroupsToGroups(myGroupsList.userGroups ?? [])
            ],
            hasMore: _cursor != null,
          ),
        );
      }
    } catch (e) {
      emit(GroupMyError(message: e.toString()));
    }
  }

  List<Group> _userGroupsToGroups(List<UserGroup> userGroups) =>
      userGroups.map((u) => u.group).toList();
}
