part of 'profile_bloc.dart';

class ProfileState {
  final User? user;
  final bool isMyProfile;
  final int gamesPlayed;
  final FriendshipState? friendshipState;
  final bool isLoading;
  final String? error;

  const ProfileState({
    this.user,
    this.isMyProfile = false,
    this.gamesPlayed = 0,
    this.friendshipState,
    this.isLoading = true,
    this.error,
  });

  ProfileState copyWith({
    User? user,
    bool? isMyProfile,
    int? gamesPlayed,
    FriendshipState? friendshipState,
    bool? isLoading,
    String? error,
  }) =>
      ProfileState(
        user: user ?? this.user,
        isMyProfile: isMyProfile ?? this.isMyProfile,
        gamesPlayed: gamesPlayed ?? this.gamesPlayed,
        friendshipState: friendshipState ?? this.friendshipState,
        isLoading: isLoading == true ? true : false,
        error: error,
      );
}
