part of 'account_bloc.dart';

sealed class AccountEvent {}

class ReadAccount extends AccountEvent {}

// class UsernameChange extends AccountEvent {
//   final String username;
//   UsernameChange(this.username);
// }

class UpdateAccount extends AccountEvent {
  final String username;
  UpdateAccount({required this.username});
}

class DeleteAccount extends AccountEvent {}

class LinkEmailAccount extends AccountEvent {
  final String email;
  final String password;

  LinkEmailAccount({required this.email, required this.password});
}

class UnlinkEmailAccount extends AccountEvent {}

class LinkGoogleAccount extends AccountEvent {}

class UnlinkGoogleAccount extends AccountEvent {}

class LinkAppleAccount extends AccountEvent {}

class UnlinkAppleAccount extends AccountEvent {}
