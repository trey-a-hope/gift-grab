import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_grab/data/services/nakama_service.dart';
import 'package:gift_grab/domain/blocs/account/account_bloc.dart';
import 'package:nakama/nakama.dart';

part 'group_user_event.dart';
part 'group_user_state.dart';

class GroupUserBloc extends Bloc<GroupUserEvent, GroupUserState> {
  final AccountBloc accountBloc;

  GroupUserBloc({required this.accountBloc}) : super(GroupUserInitial()) {
    on<LoadGroupUsersEvent>(_onLoadGroupUsersEvent);
    on<JoinGroupEvent>(_onJoinGroupEvent);
    on<LeaveGroupEvent>(_onLeaveGroupEvent);
    on<DeleteGroupEvent>(_onDeleteGroupEvent);
    on<KickUserEvent>(_onKickUserEvent);
  }

  Future<void> _onLoadGroupUsersEvent(
    LoadGroupUsersEvent event,
    Emitter<GroupUserState> emit,
  ) async {
    emit(GroupUserLoading());
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

        final groupUserList = await getNakamaClient().listGroupUsers(
          session: session,
          groupId: event.groupId,
        );

        emit(GroupUsersLoaded(uid: uid, users: groupUserList.groupUsers));
      }
    } catch (e) {
      emit(GroupUsersError(message: e.toString()));
    }
  }

  Future<void> _onJoinGroupEvent(
    JoinGroupEvent event,
    Emitter<GroupUserState> emit,
  ) async {
    emit(GroupUserLoading());

    try {
      final session = await NakamaService().getValidSession();

      if (session == null) {
        throw Exception('Session expired...');
      } else {
        await getNakamaClient().joinGroup(
          session: session,
          groupId: event.groupId,
        );

        emit(GroupUserEventSuccess('Group joined successfully', false));
      }
    } catch (e) {
      emit(GroupUsersError(message: e.toString()));
    }
  }

  Future<void> _onLeaveGroupEvent(
    LeaveGroupEvent event,
    Emitter<GroupUserState> emit,
  ) async {
    emit(GroupUserLoading());

    try {
      final session = await NakamaService().getValidSession();

      if (session == null) {
        throw Exception('Session expired...');
      } else {
        await getNakamaClient().leaveGroup(
          session: session,
          groupId: event.groupId,
        );

        emit(GroupUserEventSuccess('Left group successfully', false));
      }
    } catch (e) {
      emit(GroupUsersError(message: e.toString()));
    }
  }

  Future<void> _onDeleteGroupEvent(
    DeleteGroupEvent event,
    Emitter<GroupUserState> emit,
  ) async {
    emit(GroupUserLoading());

    try {
      final session = await NakamaService().getValidSession();

      if (session == null) {
        throw Exception('Session expired...');
      } else {
        await getNakamaClient().deleteGroup(
          session: session,
          groupId: event.groupId,
        );

        emit(GroupUserEventSuccess('Group deleted successfully', true));
      }
    } catch (e) {
      emit(GroupUsersError(message: e.toString()));
    }
  }

  Future<void> _onKickUserEvent(
    KickUserEvent event,
    Emitter<GroupUserState> emit,
  ) async {
    emit(GroupUserLoading());

    try {
      final session = await NakamaService().getValidSession();

      if (session == null) {
        throw Exception('Session expired...');
      } else {
        await getNakamaClient().kickGroupUsers(
          session: session,
          groupId: event.groupId,
          userIds: [event.uid],
        );

        emit(GroupUserEventSuccess('User kicked successfully', true));
      }
    } catch (e) {
      emit(GroupUsersError(message: e.toString()));
    }
  }
}
