import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_grab/data/services/nakama_service.dart';
import 'package:gift_grab/domain/blocs/account/account_bloc.dart';
import 'package:gift_grab/domain/blocs/account/account_bloc_extension.dart';
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
        final allGroupList = await getNakamaClient().listGroups(
          session: session,
        );

        emit(
          GroupsLoaded(
            uid: accountBloc.uid,
            entry: GroupsEntry(
              allGroups: allGroupList.groups ?? [],
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
}
