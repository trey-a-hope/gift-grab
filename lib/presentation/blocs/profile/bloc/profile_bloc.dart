import 'package:bloc/bloc.dart';
import 'package:gift_grab/data/services/nakama_session_service.dart';
import 'package:gift_grab/data/services/storage/games_played_storage.dart';
import 'package:gift_grab/presentation/blocs/account/bloc/account_bloc.dart';
import 'package:gift_grab/presentation/blocs/auth/bloc/auth_bloc.dart';
import 'package:gift_grab/presentation/extensions/list_friend_extensions.dart';
import 'package:gift_grab/presentation/services/event_handler_service.dart';
import 'package:nakama/nakama.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final String uid;
  final AuthBloc authBloc;
  final AccountBloc accountBloc;

  final NakamaSessionService _nakamaSessionService;
  final GamesPlayedStorage _gamesPlayedStorage;

  ProfileBloc(
    this.uid,
    this.authBloc,
    this.accountBloc, {
    NakamaSessionService? nakamaSessionService,
    GamesPlayedStorage? gamesPlayedStorage,
  })  : _nakamaSessionService = nakamaSessionService ?? NakamaSessionService(),
        _gamesPlayedStorage = gamesPlayedStorage ?? GamesPlayedStorage(),
        super(const ProfileState()) {
    on<ReadProfile>(
      (event, emit) async =>
          await EventHandlerService.handleBlocEvent<ProfileState>(
        action: () async {
          emit(state.copyWith(isLoading: true));

          final session = (await _nakamaSessionService.getValidSession(
            requireValid: true,
            authBloc: authBloc,
          ))!;

          final account = accountBloc.state.account!;

          final user =
              (await getNakamaClient().getUsers(session: session, ids: [uid]))
                  .first;

          final isMyProfile = account.user.id == user.id;

          final gamesPlayed = await _gamesPlayedStorage.getValue(session, uid);

          final friendsList = await getNakamaClient().listFriends(
            session: session,
            limit: 1000,
          );
          final friends = friendsList.friends;
          final friendshipState = friends?.getFriendshipState(uid);

          emit(
            state.copyWith(
              user: user,
              isMyProfile: isMyProfile,
              gamesPlayed: gamesPlayed,
              friendshipState: friendshipState,
            ),
          );
        },
        emit: emit,
        errorState: (message) => state.copyWith(error: message),
      ),
    );
  }
}
