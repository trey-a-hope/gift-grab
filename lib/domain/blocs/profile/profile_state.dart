part of 'profile_bloc.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {
  final double? progress;
  ProfileLoading({this.progress});
}

class ProfileLoaded extends ProfileState {
  final User user;
  final bool isMyProfile;
  final int gamesPlayed;
  final List<LeaderboardEntry> tournamentEntries;
  final FriendshipState? friendshipState;

  ProfileLoaded({
    required this.user,
    required this.isMyProfile,
    required this.gamesPlayed,
    required this.tournamentEntries,
    required this.friendshipState,
  });
}

class ProfileSuccess extends ProfileState {
  final String message;

  ProfileSuccess({required this.message});
}

class ProfileError extends ProfileState {
  final String message;

  ProfileError({required this.message});
}
