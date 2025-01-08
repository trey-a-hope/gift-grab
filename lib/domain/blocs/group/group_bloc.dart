import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_grab/data/services/nakama_service.dart';
import 'package:gift_grab/domain/blocs/account/account_bloc.dart';
import 'package:gift_grab/presentation/models/groups_entry.dart';
import 'package:nakama/nakama.dart';

part 'group_event.dart';
part 'group_state.dart';

class GroupBloc extends Bloc<GroupEvent, GroupState> {
  final AccountBloc accountBloc;

  GroupBloc({required this.accountBloc}) : super(GroupInitial()) {
    on<LoadGroupsEvent>(_onLoadGroups);
    on<CreateGroupEvent>(_onCreateGroup);
    on<UpdateGroupEvent>(_onUpdateGroupEvent);
  }

  Future<void> _onLoadGroups(
    LoadGroupsEvent event,
    Emitter<GroupState> emit,
  ) async {
    emit(GroupLoading());

    try {
      final session = await NakamaService().getValidSession();

      if (session == null) {
        throw Exception('Session expired...');
      } else {
        // Get the current account state to access user ID
        final accountState = accountBloc.state;
        final String uid = switch (accountState) {
          AccountLoaded() => accountState.account.user.id,
          _ => throw Exception('Account not loaded'),
        };

        final allGroupList = await getNakamaClient().listGroups(
          session: session,
        );

        // final adminGroupList = await getNakamaClient().listUserGroups(
        //   session: session,
        //   userId: uid,
        //   state: GroupMembershipState.admin,
        // );

        // final superAdminGroupList = await getNakamaClient().listUserGroups(
        //   session: session,
        //   userId: uid,
        //   state: GroupMembershipState.superadmin,
        // );

        // final memberGroupList = await getNakamaClient().listUserGroups(
        //   session: session,
        //   userId: uid,
        //   state: GroupMembershipState.member,
        // );

        // final joinRequestGroupList = await getNakamaClient().listUserGroups(
        //   session: session,
        //   userId: uid,
        //   state: GroupMembershipState.joinRequest,
        // );

        emit(
          GroupsLoaded(
            uid: uid,
            entry: GroupsEntry(
              allGroups: allGroupList.groups ?? [],
              // adminGroups: _userGroupsToGroups(adminGroupList.userGroups),
              // superAdminGroups:
              //     _userGroupsToGroups(superAdminGroupList.userGroups),
              // memberGroups: _userGroupsToGroups(memberGroupList.userGroups),
              // joinRequestGroups:
              //     _userGroupsToGroups(joinRequestGroupList.userGroups),
            ),
          ),
        );
      }
    } catch (e) {
      emit(GroupError(message: e.toString()));
    }
  }

  Future<void> _onCreateGroup(
    CreateGroupEvent event,
    Emitter<GroupState> emit,
  ) async {
    emit(GroupLoading());

    try {
      final session = await NakamaService().getValidSession();

      if (session == null) {
        throw Exception('Session expired...');
      } else {
        final newGroup = await getNakamaClient().createGroup(
          session: session,
          name: event.name,
          description: event.description,
          maxCount: event.maxCount,
          open: event.open,
        );

        debugPrint(newGroup.toString());

        emit(GroupEventSuccess('Group created successfully'));
      }
    } catch (e) {
      emit(GroupError(message: e.toString()));
    }
  }

  Future<void> _onUpdateGroupEvent(
    UpdateGroupEvent event,
    Emitter<GroupState> emit,
  ) async {
    emit(GroupLoading());

    try {
      final session = await NakamaService().getValidSession();

      if (session == null) {
        throw Exception('Session expired...');
      } else {
        await getNakamaClient().updateGroup(
          session: session,
          groupId: event.groupId,
          open: event.open,
          name: event.name,
          avatarUrl: event.avatarUrl,
          description: event.description,
          langTag: event.langTag ?? 'en', // Group language cannot be empty.
          maxCount: event.maxCount, // TODO: Count is not updating, (api bug)...
        );

        emit(GroupEventSuccess('Group updated successfully'));
      }
    } catch (e) {
      emit(GroupError(message: e.toString()));
    }
  }

  List<Group> _userGroupsToGroups(List<UserGroup>? userGroups) =>
      userGroups == null ? <Group>[] : userGroups.map((u) => u.group).toList();
}
