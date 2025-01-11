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
