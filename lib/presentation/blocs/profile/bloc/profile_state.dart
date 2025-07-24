part of 'profile_bloc.dart';

class ProfileState extends Equatable implements ErrorState {
  final User? user;
  final bool isMyProfile;
  final bool isLoading;
  final String? error;

  const ProfileState({
    this.user,
    this.isMyProfile = false,
    this.isLoading = true,
    this.error,
  });

  ProfileState copyWith({
    User? user,
    bool? isMyProfile,
    bool? isLoading,
    String? error,
  }) =>
      ProfileState(
        user: user ?? this.user,
        isMyProfile: isMyProfile ?? this.isMyProfile,
        isLoading: isLoading == true ? true : false,
        error: error,
      );

  @override
  List<Object?> get props => [
        user,
        isMyProfile,
        isLoading,
        error,
      ];
}
