import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_grab/data/services/nakama_service.dart';
import 'package:gift_grab/domain/blocs/account/account_bloc.dart';
import 'package:nakama/nakama.dart';

part 'groups_event.dart';
part 'groups_state.dart';

class GroupsBloc extends Bloc<GroupsEvent, GroupsState> {
  final AccountBloc accountBloc;

  GroupsBloc({required this.accountBloc}) : super(GroupsInitial()) {
    on<CreateGroupEvent>(_onCreateGroup);
    on<UpdateGroupEvent>(_onUpdateGroupEvent);
  }

  Future<void> _onCreateGroup(
    CreateGroupEvent event,
    Emitter<GroupsState> emit,
  ) async {
    emit(GroupsLoading());

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

        emit(GroupsActionSuccess('Group created successfully'));
      }
    } catch (e) {
      emit(GroupsError(message: e.toString()));
    }
  }

  Future<void> _onUpdateGroupEvent(
    UpdateGroupEvent event,
    Emitter<GroupsState> emit,
  ) async {
    emit(GroupsLoading());

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

        emit(GroupsActionSuccess('Group updated successfully'));
      }
    } catch (e) {
      emit(GroupsError(message: e.toString()));
    }
  }
}
