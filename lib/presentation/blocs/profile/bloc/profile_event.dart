part of 'profile_bloc.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();
}

class ReadProfile extends ProfileEvent {
  const ReadProfile();

  @override
  List<Object?> get props => [];
}
