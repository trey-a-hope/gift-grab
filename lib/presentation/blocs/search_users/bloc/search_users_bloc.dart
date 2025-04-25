import 'package:bloc/bloc.dart';
import 'package:gift_grab/data/services/nakama_session_service.dart';
import 'package:gift_grab/presentation/blocs/auth/bloc/auth_bloc.dart';
import 'package:gift_grab/presentation/services/event_handler_service.dart';
import 'package:nakama/nakama.dart';

part 'search_users_event.dart';
part 'search_users_state.dart';

class SearchUsersBloc extends Bloc<SearchUsersEvent, SearchUsersState> {
  final AuthBloc authBloc;
  final NakamaSessionService _nakamaSessionService;

  SearchUsersBloc(this.authBloc, {NakamaSessionService? nakamaSessionService})
      : _nakamaSessionService = nakamaSessionService ?? NakamaSessionService(),
        super(const SearchUsersState()) {
    on<SearchUser>(
      (event, emit) async =>
          await EventHandlerService.handleBlocEvent<SearchUsersState>(
        action: () async {
          emit(state.copyWith(isLoading: true));

          final session = (await _nakamaSessionService.getValidSession(
            requireValid: true,
            authBloc: authBloc,
          ))!;

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
    );
  }
}
