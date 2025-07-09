part of 'profile_bloc.dart';

class ProfileState extends Equatable implements ErrorState {
  final User? user;
  final bool isMyProfile;
  final bool isLoading;
  final String? success;
  final String? error;

  ProfileState({
    this.user,
    this.isMyProfile = false,
    this.isLoading = false,
    this.success,
    this.error,
  });

  ProfileState copyWith({
    User? user,
    bool? isMyProfile,
    int? gamesPlayed,
    bool? isLoading,
    String? success,
    String? error,
  }) =>
      ProfileState(
        user: user ?? this.user,
        isMyProfile: isMyProfile ?? this.isMyProfile,
        isLoading: isLoading == true ? true : false,
        success: success,
        error: error,
      );

  @override
  List<Object?> get props => [
        user,
        isMyProfile,
        isLoading,
        success,
        error,
      ];
}
