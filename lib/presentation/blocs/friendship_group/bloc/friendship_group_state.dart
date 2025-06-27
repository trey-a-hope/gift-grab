part of 'friendship_group_bloc.dart';

class FriendshipGroupState extends Equatable implements ErrorState {
  final FriendshipState friendshipState;
  final List<Friend> friends;
  final String? cursor;
  final bool isLoading;
  final String? success;
  final String? error;

  FriendshipGroupState(
    this.friendshipState, {
    this.friends = const [],
    this.cursor,
    this.isLoading = true,
    this.success,
    this.error,
  });

  FriendshipGroupState copyWith({
    List<Friend>? friends,
    String? cursor,
    bool? isLoading,
    String? success,
    String? error,
  }) =>
      FriendshipGroupState(
        friendshipState,
        friends: friends ?? this.friends,
        cursor: cursor ?? this.cursor,
        isLoading: isLoading == true ? true : false,
        success: success,
        error: error,
      );

  @override
  List<Object?> get props => [
        friendshipState,
        friends,
        cursor,
        isLoading,
        success,
        error,
      ];
}
