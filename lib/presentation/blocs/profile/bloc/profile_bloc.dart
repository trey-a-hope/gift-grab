import 'package:bloc/bloc.dart';
import 'package:gift_grab/data/services/nakama_session_service.dart';
import 'package:gift_grab/data/services/storage/games_played_storage.dart';
import 'package:gift_grab/presentation/blocs/account/bloc/account_bloc.dart';
import 'package:gift_grab/presentation/blocs/auth/bloc/auth_bloc.dart';
import 'package:gift_grab/presentation/blocs/friends/friends.dart';
import 'package:gift_grab/presentation/extensions/list_friend_extensions.dart';
import 'package:gift_grab/presentation/services/event_handler_service.dart';
import 'package:nakama/nakama.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final String uid;
  final AuthBloc authBloc;
  final AccountBloc accountBloc;
  final FriendsBloc friendsBloc;

  final NakamaSessionService _nakamaSessionService;
  final GamesPlayedStorage _gamesPlayedStorage;

  ProfileBloc(
    this.uid,
    this.authBloc,
    this.accountBloc,
    this.friendsBloc, {
    NakamaSessionService? nakamaSessionService,
    GamesPlayedStorage? gamesPlayedStorage,
  })  : _nakamaSessionService = nakamaSessionService ?? NakamaSessionService(),
        _gamesPlayedStorage = gamesPlayedStorage ?? GamesPlayedStorage(),
        super(ProfileState()) {
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
    on<SendRequest>(
      (event, emit) async {
        return await BlocHandler<ProfileState>().handle(
          action: () async {
            friendsBloc.add(AddFriend(uid));

            await for (final friendsState in friendsBloc.stream) {
              if (friendsState.success != null) {
                emit(state.copyWith(
                    friendshipState: FriendshipState.outgoingRequest,
                    success: friendsState.success!));
                break;
              }
              if (friendsState.error != null) {
                emit(state.copyWith(error: friendsState.error!));
                break;
              }
            }
          },
          emit: emit,
          state: state,
        );
      },
    );
    on<CancelRequest>(
      (event, emit) async {
        return await BlocHandler<ProfileState>().handle(
          action: () async {
            friendsBloc.add(DeleteFriend(uid));

            await for (final friendsState in friendsBloc.stream) {
              if (friendsState.success != null) {
                emit(state.copyWith(
                    clearFriendshipState: true,
                    success: friendsState.success!));
                break; // Important: break out of the loop
              }
              if (friendsState.error != null) {
                emit(state.copyWith(error: friendsState.error!));
                break; // Important: break out of the loop
              }
            }
          },
          emit: emit,
          state: state,
        );
      },
    );

    add(ReadProfile());
  }
}
