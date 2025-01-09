import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:gift_grab/data/services/nakama_service.dart';
import 'package:nakama/nakama.dart';

part 'all_groups_event.dart';
part 'all_groups_state.dart';

class AllGroupsBloc extends Bloc<AllGroupsEvent, AllGroupsState> {
  String? _cursor;

  AllGroupsBloc() : super(AllGroupsInitial()) {
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
        throw Exception('Session expired...');
      } else {
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
      }
    } catch (e) {
      emit(AllGroupsError(message: e.toString()));
    }
  }

  Future<void> _onFetchMoreGroups(
    FetchMoreGroups event,
    Emitter<AllGroupsState> emit,
  ) async {
    try {
      final session = await NakamaService().getValidSession();

      if (session == null) {
        throw Exception('Session expired...');
      } else {
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
      }
    } catch (e) {
      emit(AllGroupsError(message: e.toString()));
    }
  }
}
