part of 'account_bloc.dart';

abstract class AccountState {
  final Account? account;

  AccountState(this.account);
}

class AccountInitial extends AccountState {
  AccountInitial(super.account);
}

class AccountLoading extends AccountState {
  AccountLoading(super.account);
}

class AccountLoaded extends AccountState {
  final String currentUsername;

  AccountLoaded({
    required this.currentUsername,
    required Account account,
  }) : super(account);
}

class AccountError extends AccountState {
  final String message;

  AccountError({
    required this.message,
    required Account account,
  }) : super(account);
}

class AccountSuccess extends AccountState {
  final String message;

  AccountSuccess({
    required this.message,
    required Account account,
  }) : super(account);
}
