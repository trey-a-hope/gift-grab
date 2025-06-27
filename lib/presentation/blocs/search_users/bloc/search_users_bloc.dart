import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gift_grab/domain/services/session_service.dart';
import 'package:gift_grab_ui/bloc_handler.dart';
import 'package:nakama/nakama.dart';
import 'package:stream_transform/stream_transform.dart';

part 'search_users_event.dart';
part 'search_users_state.dart';

class SearchUsersBloc extends Bloc<SearchUsersEvent, SearchUsersState> {
  static const int _pollingTimeMs = 300;

  final SessionService sessionService;

  Timer? _debounceTimer;

  SearchUsersBloc(this.sessionService) : super(const SearchUsersState()) {
    on<SearchUser>(
      _onSearchUser,
      transformer: _debounce(
        const Duration(milliseconds: _pollingTimeMs),
      ),
    );
  }

  EventTransformer<T> _debounce<T>(Duration duration) {
    return (events, mapper) => events.debounce(duration).switchMap(mapper);
  }

  Future<void> _onSearchUser(
    SearchUser event,
    Emitter<SearchUsersState> emit,
  ) async =>
      await BlocHandler<SearchUsersState>().handle(
        action: () async {
          emit(state.copyWith(isLoading: true));

          final session = await sessionService.getSession();
          final users = await getNakamaClient().getUsers(
            session: session,
            ids: [],
            usernames: [event.username],
          );

          emit(state.copyWith(query: event.username, users: users));
        },
        emit: emit,
        state: state,
      );

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}
