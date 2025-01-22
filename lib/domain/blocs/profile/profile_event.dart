part of 'profile_bloc.dart';

abstract class ProfileEvent {}

class FetchProfile extends ProfileEvent {}

class AddFriend extends ProfileEvent {
  final String uid;

  AddFriend({required this.uid});
}

class DeleteRecord extends ProfileEvent {}

class UploadPhoto extends ProfileEvent {}
