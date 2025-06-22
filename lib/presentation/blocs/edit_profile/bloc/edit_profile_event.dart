part of 'edit_profile_bloc.dart';

sealed class EditProfileEvent {
  const EditProfileEvent();
}

class Init extends EditProfileEvent {
  Init();
}

class UsernameChanged extends EditProfileEvent {
  final String name;
  UsernameChanged(this.name);
}

class SaveForm extends EditProfileEvent {}
