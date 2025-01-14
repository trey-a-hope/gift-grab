import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:gift_grab/data/services/nakama_service.dart';
import 'package:gift_grab/domain/blocs/account/account_bloc.dart';
import 'package:gift_grab/domain/extensions/account_bloc_extension.dart';
import 'package:gift_grab/domain/blocs/auth/auth_bloc.dart';
import 'package:grpc/grpc.dart';
import 'package:nakama/nakama.dart';

part 'user_groups_event.dart';
part 'user_groups_state.dart';

class UserGroupsBloc extends Bloc<UserGroupsEvent, UserGroupsState> {
  final AccountBloc accountBloc;
  final AuthBloc authBloc;

  String? _cursor;

  UserGroupsBloc({
    required this.accountBloc,
    required this.authBloc,
  }) : super(UserGroupsInitial()) {
    on<FetchGroups>(_onFetchGroups);
    on<FetchMoreGroups>(_onFetchMoreGroups);
  }

  Future<void> _onFetchGroups(
    FetchGroups event,
    Emitter<UserGroupsState> emit,
  ) async {
    emit(UserGroupsLoading());

    try {
      final session = await NakamaService().getValidSessionOrLogout(authBloc);

      final myGroupsList = await getNakamaClient().listUserGroups(
        session: session!,
        limit: Globals.paginationLimit,
        userId: accountBloc.uid,
      );

      _cursor = myGroupsList.cursor == '' ? null : myGroupsList.cursor;

      emit(
        UserGroupsLoaded(
          groups: _userGroupsToGroups(myGroupsList.userGroups ?? []),
          hasMore: _cursor != null,
        ),
      );
    } on GrpcError catch (e) {
      emit(UserGroupsError(
          message: e.message ?? 'Unknown GRPC Error: ${e.codeName}'));
    } catch (e) {
      emit(UserGroupsError(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  Future<void> _onFetchMoreGroups(
    FetchMoreGroups event,
    Emitter<UserGroupsState> emit,
  ) async {
    try {
      final session = await NakamaService().getValidSessionOrLogout(authBloc);

      final myGroupsList = await getNakamaClient().listUserGroups(
        session: session!,
        limit: Globals.paginationLimit,
        userId: accountBloc.uid,
        cursor: _cursor,
      );

      _cursor = myGroupsList.cursor == '' ? null : myGroupsList.cursor;

      emit(
        UserGroupsLoaded(
          groups: [
            ...event.groups,
            ..._userGroupsToGroups(myGroupsList.userGroups ?? [])
          ],
          hasMore: _cursor != null,
        ),
      );
    } on GrpcError catch (e) {
      emit(UserGroupsError(
          message: e.message ?? 'Unknown GRPC Error: ${e.codeName}'));
    } catch (e) {
      emit(UserGroupsError(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  List<Group> _userGroupsToGroups(List<UserGroup> userGroups) =>
      userGroups.map((u) => u.group).toList();
}
