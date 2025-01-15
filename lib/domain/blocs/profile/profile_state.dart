part of 'profile_bloc.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final User user;
  final LeaderboardRecord? record;

  ProfileLoaded({
    required this.user,
    required this.record,
  });
}

class ProfileActionSuccess extends ProfileState {
  final String message;

  ProfileActionSuccess({required this.message});
}

class ProfileError extends ProfileState {
  final String message;

  ProfileError({required this.message});
}
