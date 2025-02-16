part of 'account_bloc.dart';

abstract class AccountEvent {}

class FetchAccount extends AccountEvent {}

class SaveAccount extends AccountEvent {
  final String username;

  SaveAccount({
    required this.username,
  });
}

class DeleteAccount extends AccountEvent {}

class LinkEmailAccount extends AccountEvent {
  final String email;
  final String password;

  LinkEmailAccount({
    required this.email,
    required this.password,
  });
}

class UnlinkEmailAccount extends AccountEvent {}

class LinkGoogleAccount extends AccountEvent {}

class UnlinkGoogleAccount extends AccountEvent {}

class LinkAppleAccount extends AccountEvent {}

class UnlinkAppleAccount extends AccountEvent {}

class UsernameChange extends AccountEvent {
  final String username;

  UsernameChange({
    required this.username,
  });
}
