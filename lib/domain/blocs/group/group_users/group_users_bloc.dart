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
    on<PromoteUserInGroup>(_onPromoteUserInGroup);
    on<DemoteUserInGroup>(_onDemoteUserInGroup);
    on<AddUserIntoGroup>(_onAddUserIntoGroup);
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

      emit(
        GroupUsersActionSuccess(
            '${event.isJoinRequest ? 'Request sent' : 'Group joined'} successfully',
            false),
      );
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

      emit(
        GroupUsersActionSuccess(
            '${event.isJoinRequest ? 'Request deleted' : 'Left group'} successfully',
            false),
      );
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

  Future<void> _onPromoteUserInGroup(
    PromoteUserInGroup event,
    Emitter<GroupUsersState> emit,
  ) async {
    emit(GroupUsersLoading());

    try {
      final session = await NakamaService().getValidSession();

      if (session == null) {
        authBloc.add(LogoutEvent());
        return;
      }

      await getNakamaClient().promoteGroupUsers(
        session: session,
        groupId: event.groupId,
        userIds: [event.uid],
      );

      emit(GroupUsersActionSuccess('User promoted successfully', false));
    } catch (e) {
      emit(GroupUsersError(message: e.toString()));
    }
  }

  Future<void> _onDemoteUserInGroup(
    DemoteUserInGroup event,
    Emitter<GroupUsersState> emit,
  ) async {
    emit(GroupUsersLoading());

    try {
      final session = await NakamaService().getValidSession();

      if (session == null) {
        authBloc.add(LogoutEvent());
        return;
      }

      await getNakamaClient().demoteGroupUsers(
        session: session,
        groupId: event.groupId,
        userIds: [event.uid],
      );

      emit(GroupUsersActionSuccess('User demoted successfully', false));
    } catch (e) {
      emit(GroupUsersError(message: e.toString()));
    }
  }

  Future<void> _onAddUserIntoGroup(
    AddUserIntoGroup event,
    Emitter<GroupUsersState> emit,
  ) async {
    emit(GroupUsersLoading());

    try {
      final session = await NakamaService().getValidSession();

      if (session == null) {
        authBloc.add(LogoutEvent());
        return;
      }

      await getNakamaClient().addGroupUsers(
        session: session,
        groupId: event.groupId,
        userIds: [event.uid],
      );

      emit(GroupUsersActionSuccess('User added successfully', false));
    } catch (e) {
      emit(GroupUsersError(message: e.toString()));
    }
  }
}
