import 'package:gift_grab/domain/blocs/group_all/group_all_event.dart';
import 'package:gift_grab/domain/blocs/group_all/group_all_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_grab/data/services/nakama_service.dart';
import 'package:nakama/nakama.dart';

class GroupAllBloc extends Bloc<GroupAllEvent, GroupAllState> {
  String? _cursor;
  final int _limit = 2;

  GroupAllBloc() : super(GroupAllInitial()) {
    on<FetchGroups>(_onFetchGroups);
    on<FetchMoreGroups>(_onFetchMoreGroups);
  }

  Future<void> _onFetchGroups(
    FetchGroups event,
    Emitter<GroupAllState> emit,
  ) async {
    emit(GroupAllLoading());

    try {
      final session = await NakamaService().getValidSession();

      if (session == null) {
        throw Exception('Session expired...');
      } else {
        final allGroupList = await getNakamaClient().listGroups(
          session: session,
          limit: _limit,
        );

        _cursor = allGroupList.cursor == '' ? null : allGroupList.cursor;

        emit(
          GroupAllLoaded(
            groups: allGroupList.groups ?? [],
            hasMore: _cursor != null,
          ),
        );
      }
    } catch (e) {
      emit(GroupAllError(message: e.toString()));
    }
  }

  Future<void> _onFetchMoreGroups(
    FetchMoreGroups event,
    Emitter<GroupAllState> emit,
  ) async {
    try {
      final session = await NakamaService().getValidSession();

      if (session == null) {
        throw Exception('Session expired...');
      } else {
        final allGroupList = await getNakamaClient().listGroups(
          session: session,
          limit: _limit,
          cursor: _cursor,
        );

        _cursor = allGroupList.cursor == '' ? null : allGroupList.cursor;

        emit(
          GroupAllLoaded(
            groups: [...event.groups, ...allGroupList.groups ?? []],
            hasMore: _cursor != null,
          ),
        );
      }
    } catch (e) {
      emit(GroupAllError(message: e.toString()));
    }
  }
}
