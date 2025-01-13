part of 'account_bloc.dart';

abstract class AccountEvent {}

class FetchAccount extends AccountEvent {}

class UpdateAccount extends AccountEvent {
  final String username;

  UpdateAccount({
    required this.username,
  });
}

class DeleteAccount extends AccountEvent {}

class LinkEmailAccount extends AccountEvent {}

class UnlinkEmailAccount extends AccountEvent {}

class LinkGoogleAccount extends AccountEvent {}

class UnlinkGoogleAccount extends AccountEvent {}

class LinkAppleAccount extends AccountEvent {}

class UnlinkAppleAccount extends AccountEvent {}
