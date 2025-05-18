part of 'friends_bloc.dart';

class FriendsState {
  final String? cursor;
  final List<Friend> friends;
  final bool isLoading;
  final String? error;

  const FriendsState({
    this.cursor,
    this.friends = const [],
    this.isLoading = false,
    this.error,
  });

  FriendsState copyWith({
    String? cursor,
    List<Friend>? friends,
    bool? isLoading,
    String? error,
  }) =>
      FriendsState(
        cursor: cursor ?? this.cursor,
        friends: friends ?? this.friends,
        isLoading: isLoading == true ? true : false,
        error: error,
      );
}
