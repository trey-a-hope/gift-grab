import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_grab/data/services/nakama_service.dart';
import 'package:gift_grab/domain/blocs/account/account_bloc.dart';
import 'package:gift_grab/domain/blocs/account/account_bloc_extension.dart';
import 'package:gift_grab/domain/blocs/auth/auth_bloc.dart';
import 'package:nakama/nakama.dart';

part 'group_users_event.dart';
part 'group_users_state.dart';

class GroupUsersBloc extends Bloc<GroupUsersEvent, GroupUsersState> {
  final AccountBloc accountBloc;
  final AuthBloc authBloc;

  GroupUsersBloc({
    required this.accountBloc,
    required this.authBloc,
  }) : super(GroupUsersInitial()) {
    on<FetchGroupUsers>(_onFetchGroupUsers);
    on<JoinGroup>(_onJoinGroup);
    on<LeaveGroup>(_onLeaveGroup);
    on<DeleteGroup>(_onDeleteGroup);
    on<KickUserFromGroup>(_onKickUserFromGroup);
    on<BanUserFromGroup>(_onBanUserFromGroup);
  }

  Future<void> _onFetchGroupUsers(
    FetchGroupUsers event,
    Emitter<GroupUsersState> emit,
  ) async {
    emit(GroupUsersLoading());

    try {
      final session = await NakamaService().getValidSession();

      if (session == null) {
        authBloc.add(LogoutEvent());
        return;
      }

      final groupUserList = await getNakamaClient().listGroupUsers(
        session: session,
        groupId: event.groupId,
      );

      emit(
        GroupUsersLoaded(
          uid: accountBloc.uid,
          users: groupUserList.groupUsers,
        ),
      );
    } catch (e) {
      emit(GroupUsersError(message: e.toString()));
    }
  }

  Future<void> _onJoinGroup(
    JoinGroup event,
    Emitter<GroupUsersState> emit,
  ) async {
    emit(GroupUsersLoading());

    try {
      final session = await NakamaService().getValidSession();

      if (session == null) {
        authBloc.add(LogoutEvent());
        return;
      }

      await getNakamaClient().joinGroup(
        session: session,
        groupId: event.groupId,
      );

      emit(GroupUsersActionSuccess('Group joined successfully', false));
    } catch (e) {
      emit(GroupUsersError(message: e.toString()));
    }
  }

  Future<void> _onLeaveGroup(
    LeaveGroup event,
    Emitter<GroupUsersState> emit,
  ) async {
    emit(GroupUsersLoading());

    try {
      final session = await NakamaService().getValidSession();

      if (session == null) {
        authBloc.add(LogoutEvent());
        return;
      }

      await getNakamaClient().leaveGroup(
        session: session,
        groupId: event.groupId,
      );

      emit(GroupUsersActionSuccess('Left group successfully', false));
    } catch (e) {
      emit(GroupUsersError(message: e.toString()));
    }
  }

  Future<void> _onDeleteGroup(
    DeleteGroup event,
    Emitter<GroupUsersState> emit,
  ) async {
    emit(GroupUsersLoading());

    try {
      final session = await NakamaService().getValidSession();

      if (session == null) {
        authBloc.add(LogoutEvent());
        return;
      }

      await getNakamaClient().deleteGroup(
        session: session,
        groupId: event.groupId,
      );

      emit(GroupUsersActionSuccess('Group deleted successfully', true));
    } catch (e) {
      emit(GroupUsersError(message: e.toString()));
    }
  }

  Future<void> _onKickUserFromGroup(
    KickUserFromGroup event,
    Emitter<GroupUsersState> emit,
  ) async {
    emit(GroupUsersLoading());

    try {
      final session = await NakamaService().getValidSession();

      if (session == null) {
        authBloc.add(LogoutEvent());
        return;
      }

      await getNakamaClient().kickGroupUsers(
        session: session,
        groupId: event.groupId,
        userIds: [event.uid],
      );

      emit(GroupUsersActionSuccess('User kicked successfully', false));
    } catch (e) {
      emit(GroupUsersError(message: e.toString()));
    }
  }

  Future<void> _onBanUserFromGroup(
    BanUserFromGroup event,
    Emitter<GroupUsersState> emit,
  ) async {
    emit(GroupUsersLoading());

    try {
      final session = await NakamaService().getValidSession();

      if (session == null) {
        authBloc.add(LogoutEvent());
        return;
      }

      await getNakamaClient().banGroupUsers(
        session: session,
        groupId: event.groupId,
        userIds: [event.uid],
      );

      emit(GroupUsersActionSuccess('User banned successfully', false));
    } catch (e) {
      emit(GroupUsersError(message: e.toString()));
    }
  }
}
