import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:gift_grab/data/services/nakama_service.dart';
import 'package:gift_grab/data/services/profanity_service.dart';
import 'package:gift_grab/domain/blocs/auth/auth_bloc.dart';
import 'package:grpc/grpc.dart';
import 'package:nakama/nakama.dart';

part 'groups_event.dart';
part 'groups_state.dart';

class GroupsBloc extends Bloc<GroupsEvent, GroupsState> {
  final AuthBloc authBloc;
  final bool allGroups;

  final ProfanityService _profanityService;

  GroupsBloc({
    required this.authBloc,
    required this.allGroups,
  })  : _profanityService = ProfanityService(),
        super(GroupsInitial(cursor: null)) {
    on<CreateGroupEvent>(_onCreateGroup);
    on<UpdateGroupEvent>(_onUpdateGroupEvent);
    on<FetchGroups>(_onFetchGroups);
    on<FetchMoreGroups>(_onFetchMoreGroups);
  }

  Future<void> _onCreateGroup(
    CreateGroupEvent event,
    Emitter<GroupsState> emit,
  ) async {
    emit(GroupsLoading(cursor: state.cursor));

    try {
      final session = await NakamaService().getValidSessionOrLogout(authBloc);

      await _profanityService.check(event.name);
      await _profanityService.check(event.description);

      final newGroup = await getNakamaClient().createGroup(
        session: session!,
        name: event.name,
        description: event.description,
        maxCount: event.maxCount,
        open: event.open,
      );

      debugPrint(newGroup.toString());

      emit(GroupsSuccess(
        message: 'Group created successfully',
        cursor: state.cursor,
      ));
    } on GrpcError catch (e) {
      emit(GroupsError(
        message: e.message ?? 'Unknown GRPC Error: ${e.codeName}',
        cursor: state.cursor,
      ));
    } catch (e) {
      emit(GroupsError(
        message: e.toString(),
        cursor: state.cursor,
      ));
    }
  }

  Future<void> _onUpdateGroupEvent(
    UpdateGroupEvent event,
    Emitter<GroupsState> emit,
  ) async {
    emit(GroupsLoading(cursor: state.cursor));

    try {
      final session = await NakamaService().getValidSessionOrLogout(authBloc);

      await _profanityService.check(event.name ?? '');
      await _profanityService.check(event.description ?? '');

      await getNakamaClient().updateGroup(
        session: session!,
        groupId: event.groupId,
        open: event.open,
        name: event.name,
        avatarUrl: event.avatarUrl,
        description: event.description,
        langTag: event.langTag ?? 'en', // Group language cannot be empty.
        maxCount: event
            .maxCount, // TODO: https://github.com/heroiclabs/nakama-dart/issues/123
      );

      emit(GroupsSuccess(
        message: 'Group updated successfully',
        cursor: state.cursor,
      ));
    } on GrpcError catch (e) {
      emit(GroupsError(
        message: e.message ?? 'Unknown GRPC Error: ${e.codeName}',
        cursor: state.cursor,
      ));
    } catch (e) {
      emit(GroupsError(
        message: e.toString(),
        cursor: state.cursor,
      ));
    }
  }

  Future<void> _onFetchGroups(
    FetchGroups event,
    Emitter<GroupsState> emit,
  ) async {
    emit(GroupsLoading(cursor: state.cursor));

    try {
      final session = await NakamaService().getValidSessionOrLogout(authBloc);

      late List<Group> groups;
      late String? cursor;

      if (allGroups) {
        final allGroupList = await getNakamaClient().listGroups(
          session: session!,
          limit: Globals.paginationLimit,
        );
        cursor = allGroupList.cursor == '' ? null : allGroupList.cursor;
        groups = allGroupList.groups ?? [];
      } else {
        final uid = (await getNakamaClient().getAccount(session!)).user.id;
        final myGroupsList = await getNakamaClient().listUserGroups(
          session: session,
          limit: Globals.paginationLimit,
          userId: uid,
        );
        cursor = myGroupsList.cursor == '' ? null : myGroupsList.cursor;
        groups = _userGroupsToGroups(myGroupsList.userGroups ?? []);
      }

      emit(
        GroupsLoaded(
          groups: groups,
          cursor: cursor,
        ),
      );
    } on GrpcError catch (e) {
      emit(GroupsError(
        message: e.message ?? 'Unknown GRPC Error: ${e.codeName}',
        cursor: state.cursor,
      ));
    } catch (e) {
      emit(GroupsError(
        message: 'Unexpected error: ${e.toString()}',
        cursor: state.cursor,
      ));
    }
  }

  Future<void> _onFetchMoreGroups(
    FetchMoreGroups event,
    Emitter<GroupsState> emit,
  ) async {
    try {
      final session = await NakamaService().getValidSessionOrLogout(authBloc);

      late List<Group> groups;
      late String? cursor;

      if (allGroups) {
        final allGroupList = await getNakamaClient().listGroups(
          session: session!,
          limit: Globals.paginationLimit,
          cursor: state.cursor,
        );
        cursor = allGroupList.cursor == '' ? null : allGroupList.cursor;
        groups = allGroupList.groups ?? [];
      } else {
        final uid = (await getNakamaClient().getAccount(session!)).user.id;
        final myGroupsList = await getNakamaClient().listUserGroups(
          session: session,
          limit: Globals.paginationLimit,
          userId: uid,
          cursor: state.cursor,
        );
        cursor = myGroupsList.cursor == '' ? null : myGroupsList.cursor;
        groups = _userGroupsToGroups(myGroupsList.userGroups ?? []);
      }

      emit(
        GroupsLoaded(
          groups: [...event.groups, ...groups],
          cursor: cursor,
        ),
      );
    } on GrpcError catch (e) {
      emit(GroupsError(
        message: e.message ?? 'Unknown GRPC Error: ${e.codeName}',
        cursor: state.cursor,
      ));
    } catch (e) {
      emit(GroupsError(
        message: 'Unexpected error: ${e.toString()}',
        cursor: state.cursor,
      ));
    }
  }

  List<Group> _userGroupsToGroups(List<UserGroup> userGroups) =>
      userGroups.map((u) => u.group).toList();
}

class AllGroupsBloc extends GroupsBloc {
  AllGroupsBloc({required super.authBloc}) : super(allGroups: true);
}

class MyGroupsBloc extends GroupsBloc {
  MyGroupsBloc({required super.authBloc}) : super(allGroups: false);
}
