import 'package:bloc/bloc.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:gift_grab/data/services/nakama_session_service.dart';
import 'package:gift_grab/presentation/blocs/auth/bloc/auth_bloc.dart';
import 'package:gift_grab/presentation/services/event_handler_service.dart';
import 'package:nakama/nakama.dart';

part 'friends_event.dart';
part 'friends_state.dart';

class FriendsBloc extends Bloc<FriendsEvent, FriendsState> {
  final AuthBloc authBloc;
  final NakamaSessionService _nakamaSessionService;
  final FriendshipState? friendshipState;

  FriendsBloc(
    this.authBloc, {
    this.friendshipState,
    NakamaSessionService? nakamaSessionService,
  })  : _nakamaSessionService = nakamaSessionService ?? NakamaSessionService(),
        super(const FriendsState()) {
    on<AddFriend>((event, emit) async {
      return await EventHandlerService.handleBlocEvent<FriendsState>(
        action: () async {
          // Set loading state to show a loading indicator in the UI
          emit(state.copyWith(isLoading: true));

          // Get a valid Nakama session, requiring authentication through authBloc if needed
          final session = (await _nakamaSessionService.getValidSession(
            requireValid: true,
            authBloc: authBloc,
          ))!;

          await getNakamaClient().addFriends(
            session: session,
            ids: [event.uid],
          );
        },
        emit: emit,
        errorState: (message) => state.copyWith(error: message),
      );
    });
    on<FetchFriends>((event, emit) async {
      return await EventHandlerService.handleBlocEvent<FriendsState>(
        action: () async {
          emit(state.copyWith(isLoading: true));

          final session = (await _nakamaSessionService.getValidSession(
            requireValid: true,
            authBloc: authBloc,
          ))!;

          final friendsList = await getNakamaClient().listFriends(
            session: session,
            limit: Globals.paginationLimit,
            friendshipState: friendshipState,
            cursor: state.cursor,
          );

          final cursor = friendsList.cursor == '' ? null : friendsList.cursor;

          final friends = friendsList.friends ?? [];

          emit(
            FriendsState(
              friends: [...state.friends, ...friends],
              cursor: cursor,
            ),
          );
        },
        emit: emit,
        errorState: (message) => state.copyWith(error: message),
      );
    });
  }
}
