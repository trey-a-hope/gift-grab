import 'package:bloc/bloc.dart';
import 'package:gift_grab/domain/services/games_played_storage_service.dart';
import 'package:gift_grab/domain/services/session_service.dart';
import 'package:gift_grab/presentation/blocs/account/bloc/account_bloc.dart';
import 'package:gift_grab/presentation/blocs/friends/friends.dart';
import 'package:gift_grab/presentation/extensions/list_friend_extensions.dart';
import 'package:gift_grab/presentation/services/event_handler_service.dart';
import 'package:nakama/nakama.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final String uid;
  final AccountBloc accountBloc;
  final FriendsBloc friendsBloc;

  final SessionService sessionService;
  final GamesPlayedStorageService gamesPlayedStorageService;

  ProfileBloc(
    this.sessionService,
    this.gamesPlayedStorageService,
    this.uid,
    this.accountBloc,
    this.friendsBloc,
  ) : super(ProfileState()) {
    on<ReadProfile>(_onReadProfile);
    on<SendRequest>(_onSendRequest);
    on<AcceptIncomingRequest>(_onAcceptIncomingRequest);
    on<CancelOutgoingRequest>(_onCancelOutgoingRequest);
    on<RejectIncomingRequest>(_onRejectIncomingRequest);
    on<DeleteFriend>(_onDeleteFriend);
    on<BlockFriend>(_onBlockFriend);
    on<UnblockFriend>(_onUnblockFriend);

    add(ReadProfile());
  }

  Future<void> _onReadProfile(
    ReadProfile event,
    Emitter<ProfileState> emit,
  ) async {
    return await EventHandlerService.handleBlocEvent<ProfileState>(
      action: () async {
        emit(state.copyWith(isLoading: true));

        final session = (await sessionService.getSession());

        final account = accountBloc.state.account!;

        final user = (await getNakamaClient().getUsers(
          session: session,
          ids: [uid],
        ))
            .first;

        final isMyProfile = account.user.id == user.id;

        final gamesPlayed =
            await gamesPlayedStorageService.getValue(session, uid);

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
              friendshipState: friendshipState),
        );
      },
      emit: emit,
      errorState: (message) => state.copyWith(error: message),
    );
  }

  Future<void> _onSendRequest(
    SendRequest event,
    Emitter<ProfileState> emit,
  ) async {
    return await EventHandlerService.handleBlocEvent<ProfileState>(
      action: () async {
        friendsBloc.add(Add(uid));

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
      errorState: (message) => state.copyWith(error: message),
    );
  }

  Future<void> _onAcceptIncomingRequest(
    AcceptIncomingRequest event,
    Emitter<ProfileState> emit,
  ) async =>
      await BlocHandler<ProfileState>().handle(
        action: () async {
          friendsBloc.add(Add(uid));

          await for (final friendsState in friendsBloc.stream) {
            if (friendsState.success != null) {
              emit(state.copyWith(
                success: 'Request accepted',
                friendshipState: FriendshipState.mutual,
              ));
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

  Future<void> _onCancelOutgoingRequest(
    CancelOutgoingRequest event,
    Emitter<ProfileState> emit,
  ) async =>
      await BlocHandler<ProfileState>().handle(
        action: () async {
          friendsBloc.add(Delete(uid));

          await for (final friendsState in friendsBloc.stream) {
            if (friendsState.success != null) {
              emit(state.copyWith(
                success: 'Request canceled',
                clearFriendshipState: true,
              ));
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

  Future<void> _onRejectIncomingRequest(
    RejectIncomingRequest event,
    Emitter<ProfileState> emit,
  ) async =>
      await BlocHandler<ProfileState>().handle(
        action: () async {
          friendsBloc.add(Delete(uid));

          await for (final friendsState in friendsBloc.stream) {
            if (friendsState.success != null) {
              emit(state.copyWith(
                success: 'Request rejected',
                clearFriendshipState: true,
              ));
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

  Future<void> _onDeleteFriend(
    DeleteFriend event,
    Emitter<ProfileState> emit,
  ) async =>
      await BlocHandler<ProfileState>().handle(
        action: () async {
          friendsBloc.add(Delete(uid));

          await for (final friendsState in friendsBloc.stream) {
            if (friendsState.success != null) {
              emit(state.copyWith(
                success: 'Friend Deleted',
                clearFriendshipState: true,
              ));
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

  Future<void> _onBlockFriend(
    BlockFriend event,
    Emitter<ProfileState> emit,
  ) async =>
      await BlocHandler<ProfileState>().handle(
        action: () async {
          friendsBloc.add(Block(uid));

          await for (final friendsState in friendsBloc.stream) {
            if (friendsState.success != null) {
              emit(state.copyWith(
                success: 'Friend blocked',
                friendshipState: FriendshipState.blocked,
              ));
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

  Future<void> _onUnblockFriend(
    UnblockFriend event,
    Emitter<ProfileState> emit,
  ) async =>
      await BlocHandler<ProfileState>().handle(
        action: () async {
          friendsBloc.add(Delete(uid));

          await for (final friendsState in friendsBloc.stream) {
            if (friendsState.success != null) {
              emit(state.copyWith(
                success: 'Friend unblocked',
                clearFriendshipState: true,
              ));
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
}
