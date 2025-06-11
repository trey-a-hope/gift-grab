part of 'friendship_state_bloc.dart';

class FriendshipStateState extends BaseState {
  final FriendshipState friendshipState;
  final List<Friend> friends;
  final String? cursor;
  final bool isLoading;
  final String? success;

  final String? error;

  FriendshipStateState(
    this.friendshipState, {
    this.friends = const [],
    this.cursor,
    this.isLoading = true,
    this.success,
    this.error,
  });

  FriendshipStateState copyWith({
    List<Friend>? friends,
    String? cursor,
    bool? isLoading,
    String? success,
    String? error,
  }) =>
      FriendshipStateState(
        friendshipState,
        friends: friends ?? this.friends,
        cursor: cursor ?? this.cursor,
        isLoading: isLoading == true ? true : false,
        success: success,
        error: error,
      );
}
