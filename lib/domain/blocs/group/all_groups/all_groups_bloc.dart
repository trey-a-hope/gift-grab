import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:gift_grab/data/services/nakama_service.dart';
import 'package:gift_grab/domain/blocs/auth/auth_bloc.dart';
import 'package:gift_grab/domain/mixins/grpc_error_handler_mixin.dart';
import 'package:grpc/grpc.dart';
import 'package:nakama/nakama.dart';

part 'all_groups_event.dart';
part 'all_groups_state.dart';

class AllGroupsBloc extends Bloc<AllGroupsEvent, AllGroupsState>
    with GrpcErrorHandlerMixin<AllGroupsState> {
  final AuthBloc authBloc;

  String? _cursor;

  AllGroupsBloc({required this.authBloc}) : super(AllGroupsInitial()) {
    on<FetchGroups>(_onFetchGroups);
    on<FetchMoreGroups>(_onFetchMoreGroups);
  }

  Future<void> _onFetchGroups(
    FetchGroups event,
    Emitter<AllGroupsState> emit,
  ) async {
    emit(AllGroupsLoading());

    try {
      final session = await NakamaService().getValidSession();

      if (session == null) {
        authBloc.add(Logout());
        return;
      }

      final allGroupList = await getNakamaClient().listGroups(
        session: session,
        limit: Globals.paginationLimit,
      );

      _cursor = allGroupList.cursor == '' ? null : allGroupList.cursor;

      emit(
        AllGroupsLoaded(
          groups: allGroupList.groups ?? [],
          hasMore: _cursor != null,
        ),
      );
    } on GrpcError catch (e) {
      handleGrpcError(e, emit, (message) => AllGroupsError(message: message));
    } catch (e) {
      emit(AllGroupsError(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  Future<void> _onFetchMoreGroups(
    FetchMoreGroups event,
    Emitter<AllGroupsState> emit,
  ) async {
    try {
      final session = await NakamaService().getValidSession();

      if (session == null) {
        authBloc.add(Logout());
        return;
      }

      final allGroupList = await getNakamaClient().listGroups(
        session: session,
        limit: Globals.paginationLimit,
        cursor: _cursor,
      );

      _cursor = allGroupList.cursor == '' ? null : allGroupList.cursor;

      emit(
        AllGroupsLoaded(
          groups: [...event.groups, ...allGroupList.groups ?? []],
          hasMore: _cursor != null,
        ),
      );
    } on GrpcError catch (e) {
      handleGrpcError(e, emit, (message) => AllGroupsError(message: message));
    } catch (e) {
      emit(AllGroupsError(message: 'Unexpected error: ${e.toString()}'));
    }
  }
}
