import 'package:flutter_bloc/flutter_bloc.dart';

part '../friend/friend_event.dart';
part '../friend/friend_state.dart';

class FriendBloc extends Bloc<FriendEvent, FriendState> {
  final AuthBloc authBloc;
  final NakamaService _nakamaService;

  FriendBloc({
    required this.authBloc,
  })  : _nakamaService = NakamaService(),
        super(FriendsInitial(cursor: null)) {
    on<FetchFriends>(_onFetchFriends);
    on<FetchMoreFriends>(_onFetchMoreFriends);
    on<CreateFriend>(_onCreateFriend);
    on<ReadFriend>(_onReadFriend);
    on<UpdateFriend>(_onUpdateFriend);
    on<DeleteFriend>(_onDeleteFriend);
  }

  
  Future<void> _onFetchFriends(
    FetchFriends event,
    Emitter<FriendState> emit,
  ) async {
    emit(FriendsLoading(cursor: state.cursor));

    try {
      // TODO: Implement fetch logic here
      // final response = await _nakamaService.fetchFriend();
      // final friend = response.friend;
      // final cursor = response.cursor;

      emit(
        FriendsLoaded(
          friend: friend,
          cursor: cursor,
        ),
      );
    } on GrpcError catch (e) {
      emit(
        FriendsError(
          message: e.message ?? 'Unknown GRPC Error: ${e.codeName}',
          cursor: state.cursor,
        ),
      );
    } catch (e) {
      emit(
        FriendsError(
          message: 'Unexpected error: ${e.toString()}',
          cursor: state.cursor,
        ),
      );
    }
  }

  Future<void> _onFetchMoreFriends(
    FetchMoreFriends event,
    Emitter<FriendState> emit,
  ) async {
    emit(FriendsLoading(cursor: state.cursor));

    try {
      // TODO: Implement fetch more logic here
      // final response = await _nakamaService.fetchFriend(cursor: state.cursor);
      // final friend = response.friend;
      // final cursor = response.cursor;

      if (state is FriendsLoaded) {
        final currentState = state as FriendsLoaded;
        emit(
          FriendsLoaded(
            friends: [...currentState.friends, ...friends],
            cursor: cursor,
          ),
        );
      }
    } on GrpcError catch (e) {
      emit(
        FriendsError(
          message: e.message ?? 'Unknown GRPC Error: ${e.codeName}',
          cursor: state.cursor,
        ),
      );
    } catch (e) {
      emit(
        FriendsError(
          message: 'Unexpected error: ${e.toString()}',
          cursor: state.cursor,
        ),
      );
    }
  }
  

  
  Future<void> _onCreateFriend(
    CreateFriend event,
    Emitter<FriendState> emit,
  ) async {
    emit(FriendsLoading(cursor: state.cursor));

    try {
      // TODO: Implement create logic here
      // await _nakamaService.createFriend(event.data);

      emit(
        FriendsSuccess(
          message: 'Friend created successfully',
          cursor: state.cursor,
        ),
      );
    } on GrpcError catch (e) {
      emit(
        FriendsError(
          message: e.message ?? 'Unknown GRPC Error: ${e.codeName}',
          cursor: state.cursor,
        ),
      );
    } catch (e) {
      emit(
        FriendsError(
          message: 'Unexpected error: ${e.toString()}',
          cursor: state.cursor,
        ),
      );
    }
  }
  

  
  Future<void> _onReadFriend(
    ReadFriend event,
    Emitter<FriendState> emit,
  ) async {
    emit(FriendLoading(cursor: state.cursor));

    try {
      // TODO: Implement read logic here
      // final friend = await _nakamaService.readFriend(event.id);

      emit(
        FriendLoaded(
          friend: friend,
          cursor: state.cursor,
        ),
      );
    } on GrpcError catch (e) {
      emit(
        FriendError(
          message: e.message ?? 'Unknown GRPC Error: ${e.codeName}',
          cursor: state.cursor,
        ),
      );
    } catch (e) {
      emit(
        FriendError(
          message: 'Unexpected error: ${e.toString()}',
          cursor: state.cursor,
        ),
      );
    }
  }
  

  
  Future<void> _onUpdateFriend(
    UpdateFriend event,
    Emitter<FriendState> emit,
  ) async {
    emit(FriendLoading(cursor: state.cursor));

    try {
      // TODO: Implement update logic here
      // await _nakamaService.updateFriend(event.id, event.data);

      emit(
        FriendSuccess(
          message: 'Friend updated successfully',
          cursor: state.cursor,
        ),
      );
    } on GrpcError catch (e) {
      emit(
        FriendError(
          message: e.message ?? 'Unknown GRPC Error: ${e.codeName}',
          cursor: state.cursor,
        ),
      );
    } catch (e) {
      emit(
        FriendError(
          message: 'Unexpected error: ${e.toString()}',
          cursor: state.cursor,
        ),
      );
    }
  }
  

  
  Future<void> _onDeleteFriend(
    DeleteFriend event,
    Emitter<FriendState> emit,
  ) async {
    emit(FriendLoading(cursor: state.cursor));

    try {
      // TODO: Delete logic here...

      emit(
        FriendSuccess(
          message: 'Friend deleted successfully',
          cursor: state.cursor,
        ),
      );
    } on GrpcError catch (e) {
      emit(FriendError(
          cursor: state.cursor,
          message: e.message ?? 'Unknown GRPC Error: ${e.codeName}'));
    } catch (e) {
      emit(
        FriendError(
          cursor: state.cursor,
          message: 'Unexpected error: ${e.toString()}',
        ),
      );
    }
  }
  
}