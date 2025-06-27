part of 'profile_bloc.dart';

class ProfileState extends Equatable implements ErrorState {
  final User? user;
  final bool isMyProfile;
  final int gamesPlayed;
  final FriendshipState? friendshipState;
  final bool isLoading;
  final String? success;
  final String? error;

  ProfileState({
    this.user,
    this.isMyProfile = false,
    this.gamesPlayed = 0,
    this.friendshipState,
    this.isLoading = true,
    this.success,
    this.error,
  });

  ProfileState copyWith({
    User? user,
    bool? isMyProfile,
    int? gamesPlayed,
    FriendshipState? friendshipState,
    bool clearFriendshipState = false,
    bool? isLoading,
    String? success,
    String? error,
  }) =>
      ProfileState(
        user: user ?? this.user,
        isMyProfile: isMyProfile ?? this.isMyProfile,
        gamesPlayed: gamesPlayed ?? this.gamesPlayed,
        friendshipState: clearFriendshipState
            ? null
            : (friendshipState ?? this.friendshipState),
        isLoading: isLoading == true ? true : false,
        success: success,
        error: error,
      );

  @override
  List<Object?> get props => [
        user,
        isMyProfile,
        gamesPlayed,
        friendshipState,
        isLoading,
        success,
        error,
      ];
}
