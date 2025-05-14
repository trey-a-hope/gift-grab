part of 'profile_bloc.dart';

class ProfileState {
  final User? user;
  final bool isMyProfile;
  final int gamesPlayed;
  final bool isLoading;
  final String? error;

  const ProfileState({
    this.user,
    this.isMyProfile = false,
    this.gamesPlayed = 0,
    this.isLoading = true,
    this.error,
  });

  ProfileState copyWith({
    User? user,
    bool? isMyProfile,
    int? gamesPlayed,
    bool? isLoading,
    String? error,
  }) =>
      ProfileState(
        user: user ?? this.user,
        isMyProfile: isMyProfile ?? this.isMyProfile,
        gamesPlayed: gamesPlayed ?? this.gamesPlayed,
        isLoading: isLoading == true ? true : false,
        error: error,
      );
}
