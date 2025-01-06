import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_grab/data/services/nakama_service.dart';
import 'package:gift_grab/domain/blocs/account/account_bloc.dart';
import 'package:gift_grab/presentation/models/groups_entry.dart';
import 'package:nakama/nakama.dart';

part 'group_event.dart';
part 'group_state.dart';

class GroupBloc extends Bloc<GroupEvent, GroupState> {
  final AccountBloc accountBloc; // Add this line

  GroupBloc({required this.accountBloc}) : super(GroupInitial()) {
    on<LoadGroupsEvent>(_onLoadGroups);
    on<CreateGroupEvent>(_onCreateGroup);
    on<DeleteGroupEvent>(_onDeleteGroup);
    on<JoinGroupEvent>(_onJoinGroup);
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

        final myGroupList = await getNakamaClient().listUserGroups(
          session: session,
          userId: uid,
        );

        emit(
          GroupsLoaded(
            uid: uid,
            entry: GroupsEntry(
              allGroups: allGroupList.groups ?? [],
              myGroups: myGroupList.userGroups!.map((m) => m.group).toList(),
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

        add(LoadGroupsEvent());
      }
    } catch (e) {
      emit(GroupError(message: e.toString()));
    }
  }

  Future<void> _onDeleteGroup(
    DeleteGroupEvent event,
    Emitter<GroupState> emit,
  ) async {
    emit(GroupLoading());

    try {
      final session = await NakamaService().getValidSession();

      if (session == null) {
        throw Exception('Session expired...');
      } else {
        await getNakamaClient().deleteGroup(
          session: session,
          groupId: 'GROUP ID',
        );

        add(LoadGroupsEvent());
      }
    } catch (e) {
      emit(GroupError(message: e.toString()));
    }
  }

  Future<void> _onJoinGroup(
    JoinGroupEvent event,
    Emitter<GroupState> emit,
  ) async {
    emit(GroupLoading());

    try {
      final session = await NakamaService().getValidSession();

      if (session == null) {
        throw Exception('Session expired...');
      } else {
        await getNakamaClient().joinGroup(
          session: session,
          groupId: 'GROUPID',
        );

        add(LoadGroupsEvent());
      }
    } catch (e) {
      emit(GroupError(message: e.toString()));
    }
  }
}
