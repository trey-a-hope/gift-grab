part of 'account_bloc.dart';

abstract class AccountEvent {}

class FetchAccountEvent extends AccountEvent {}

class UpdateAccountEvent extends AccountEvent {
  final String username;

  UpdateAccountEvent({
    required this.username,
  });
}

class DeleteAccountEvent extends AccountEvent {}
