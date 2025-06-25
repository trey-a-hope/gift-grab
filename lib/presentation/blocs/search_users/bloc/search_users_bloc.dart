import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:gift_grab/data/services/nakama_session_service.dart';
import 'package:gift_grab/presentation/services/event_handler_service.dart';
import 'package:nakama/nakama.dart';
import 'package:stream_transform/stream_transform.dart';

part 'search_users_event.dart';
part 'search_users_state.dart';

class SearchUsersBloc extends Bloc<SearchUsersEvent, SearchUsersState> {
  static const int _pollingTimeMs = 300;

  final NakamaSessionService _nakamaSessionService;

  Timer? _debounceTimer;

  SearchUsersBloc({
    NakamaSessionService? nakamaSessionService,
  })  : _nakamaSessionService = nakamaSessionService ?? NakamaSessionService(),
        super(const SearchUsersState()) {
    on<SearchUser>(
      (event, emit) async =>
          await EventHandlerService.handleBlocEvent<SearchUsersState>(
        action: () async {
          emit(state.copyWith(isLoading: true));

          final session = (await _nakamaSessionService.getSession());
          final users = await getNakamaClient().getUsers(
            session: session,
            ids: [],
            usernames: [event.username],
          );

          emit(state.copyWith(query: event.username, users: users));
        },
        emit: emit,
        errorState: (message) => state.copyWith(error: message),
      ),
      transformer: _debounce(const Duration(milliseconds: _pollingTimeMs)),
    );
  }

  EventTransformer<T> _debounce<T>(Duration duration) {
    return (events, mapper) => events.debounce(duration).switchMap(mapper);
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}
