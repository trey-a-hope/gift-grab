part of 'account_bloc.dart';

class AccountState {
  final Account? account;
  final String? currentUsername;
  final bool isLoading;
  final String? error;
  final String? success;

  const AccountState({
    this.account,
    this.currentUsername,
    this.isLoading = true,
    this.error,
    this.success,
  });

  AccountState copyWith({
    Account? account,
    String? currentUsername,
    bool? isLoading,
    String? error,
    String? success,
  }) =>
      AccountState(
        account: account ?? this.account,
        currentUsername: currentUsername ?? this.currentUsername,
        isLoading: isLoading == true ? true : false,
        error: error,
        success: success,
      );
}
