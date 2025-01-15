import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_grab/data/services/nakama_service.dart';
import 'package:gift_grab/domain/blocs/auth/auth_bloc.dart';
import 'package:grpc/grpc.dart';
import 'package:nakama/nakama.dart';

part 'group_users_event.dart';
part 'group_users_state.dart';

class GroupUsersBloc extends Bloc<GroupUsersEvent, GroupUsersState> {
  final AuthBloc authBloc;

  GroupUsersBloc({
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
      final session = await NakamaService().getValidSessionOrLogout(authBloc);

      final uid = (await getNakamaClient().getAccount(session!)).user.id;

      final groupUserList = await getNakamaClient().listGroupUsers(
        session: session,
        groupId: event.groupId,
      );

      // If no users, that means the group was deleted; navigate back.
      if (groupUserList.groupUsers.isEmpty) {
        emit(GroupUsersGoToRoute('groups'));
        return;
      }

      emit(
        GroupUsersLoaded(
          uid: uid,
          users: groupUserList.groupUsers,
        ),
      );
    } on GrpcError catch (e) {
      emit(GroupUsersError(
          message: e.message ?? 'Unknown GRPC Error: ${e.codeName}'));
    } catch (e) {
      emit(GroupUsersError(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  Future<void> _onJoinGroup(
    JoinGroup event,
    Emitter<GroupUsersState> emit,
  ) async {
    emit(GroupUsersLoading());

    try {
      final session = await NakamaService().getValidSessionOrLogout(authBloc);

      await getNakamaClient().joinGroup(
        session: session!,
        groupId: event.groupId,
      );

      emit(
        GroupUsersActionSuccess(
            '${event.isJoinRequest ? 'Request sent' : 'Group joined'} successfully',
            false),
      );
    } on GrpcError catch (e) {
      emit(GroupUsersError(
          message: e.message ?? 'Unknown GRPC Error: ${e.codeName}'));
    } catch (e) {
      emit(GroupUsersError(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  Future<void> _onLeaveGroup(
    LeaveGroup event,
    Emitter<GroupUsersState> emit,
  ) async {
    emit(GroupUsersLoading());

    try {
      final session = await NakamaService().getValidSessionOrLogout(authBloc);

      await getNakamaClient().leaveGroup(
        session: session!,
        groupId: event.groupId,
      );

      emit(
        GroupUsersActionSuccess(
            '${event.isJoinRequest ? 'Request deleted' : 'Left group'} successfully',
            false),
      );
    } on GrpcError catch (e) {
      emit(GroupUsersError(
          message: e.message ?? 'Unknown GRPC Error: ${e.codeName}'));
    } catch (e) {
      emit(GroupUsersError(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteGroup(
    DeleteGroup event,
    Emitter<GroupUsersState> emit,
  ) async {
    emit(GroupUsersLoading());

    try {
      final session = await NakamaService().getValidSessionOrLogout(authBloc);

      await getNakamaClient().deleteGroup(
        session: session!,
        groupId: event.groupId,
      );

      emit(GroupUsersActionSuccess('Group deleted successfully', true));
    } on GrpcError catch (e) {
      emit(GroupUsersError(
          message: e.message ?? 'Unknown GRPC Error: ${e.codeName}'));
    } catch (e) {
      emit(GroupUsersError(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  Future<void> _onKickUserFromGroup(
    KickUserFromGroup event,
    Emitter<GroupUsersState> emit,
  ) async {
    emit(GroupUsersLoading());

    try {
      final session = await NakamaService().getValidSessionOrLogout(authBloc);

      await getNakamaClient().kickGroupUsers(
        session: session!,
        groupId: event.groupId,
        userIds: [event.uid],
      );

      emit(GroupUsersActionSuccess('User kicked successfully', false));
    } on GrpcError catch (e) {
      emit(GroupUsersError(
          message: e.message ?? 'Unknown GRPC Error: ${e.codeName}'));
    } catch (e) {
      emit(GroupUsersError(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  Future<void> _onBanUserFromGroup(
    BanUserFromGroup event,
    Emitter<GroupUsersState> emit,
  ) async {
    emit(GroupUsersLoading());

    try {
      final session = await NakamaService().getValidSessionOrLogout(authBloc);

      await getNakamaClient().banGroupUsers(
        session: session!,
        groupId: event.groupId,
        userIds: [event.uid],
      );

      emit(GroupUsersActionSuccess('User banned successfully', false));
    } on GrpcError catch (e) {
      emit(GroupUsersError(
          message: e.message ?? 'Unknown GRPC Error: ${e.codeName}'));
    } catch (e) {
      emit(GroupUsersError(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  Future<void> _onPromoteUserInGroup(
    PromoteUserInGroup event,
    Emitter<GroupUsersState> emit,
  ) async {
    emit(GroupUsersLoading());

    try {
      final session = await NakamaService().getValidSessionOrLogout(authBloc);

      await getNakamaClient().promoteGroupUsers(
        session: session!,
        groupId: event.groupId,
        userIds: [event.uid],
      );

      emit(GroupUsersActionSuccess('User promoted successfully', false));
    } on GrpcError catch (e) {
      emit(GroupUsersError(
          message: e.message ?? 'Unknown GRPC Error: ${e.codeName}'));
    } catch (e) {
      emit(GroupUsersError(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  Future<void> _onDemoteUserInGroup(
    DemoteUserInGroup event,
    Emitter<GroupUsersState> emit,
  ) async {
    emit(GroupUsersLoading());

    try {
      final session = await NakamaService().getValidSessionOrLogout(authBloc);

      await getNakamaClient().demoteGroupUsers(
        session: session!,
        groupId: event.groupId,
        userIds: [event.uid],
      );

      emit(GroupUsersActionSuccess('User demoted successfully', false));
    } on GrpcError catch (e) {
      emit(GroupUsersError(
          message: e.message ?? 'Unknown GRPC Error: ${e.codeName}'));
    } catch (e) {
      emit(GroupUsersError(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  Future<void> _onAddUserIntoGroup(
    AddUserIntoGroup event,
    Emitter<GroupUsersState> emit,
  ) async {
    emit(GroupUsersLoading());

    try {
      final session = await NakamaService().getValidSessionOrLogout(authBloc);

      await getNakamaClient().addGroupUsers(
        session: session!,
        groupId: event.groupId,
        userIds: [event.uid],
      );

      emit(GroupUsersActionSuccess('User added successfully', false));
    } on GrpcError catch (e) {
      emit(GroupUsersError(
          message: e.message ?? 'Unknown GRPC Error: ${e.codeName}'));
    } catch (e) {
      emit(GroupUsersError(message: 'Unexpected error: ${e.toString()}'));
    }
  }
}
