part of 'edit_profile_bloc.dart';

sealed class EditProfileEvent extends Equatable {
  const EditProfileEvent();
}

class Init extends EditProfileEvent {
  const Init();

  @override
  List<Object?> get props => [];
}

class UsernameChanged extends EditProfileEvent {
  final String name;

  const UsernameChanged(this.name);

  @override
  List<Object?> get props => [name];
}

class SaveForm extends EditProfileEvent {
  const SaveForm();

  @override
  List<Object?> get props => [];
}
