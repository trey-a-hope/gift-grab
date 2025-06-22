part of 'account_bloc.dart';

class AccountState {
  final Account? account;
  final Name currentUsername;
  final FormzSubmissionStatus status;
  final bool isLoading;
  final String? error;
  final String? success;

  const AccountState({
    this.account,
    this.currentUsername = const Name.pure(),
    this.status = FormzSubmissionStatus.inProgress,
    this.isLoading = true,
    this.error,
    this.success,
  });

  AccountState copyWith({
    Account? account,
    Name? currentUsername,
    FormzSubmissionStatus? status,
    bool? isLoading,
    String? error,
    String? success,
  }) =>
      AccountState(
        account: account ?? this.account,
        currentUsername: currentUsername ?? this.currentUsername,
        status: status ?? this.status,
        isLoading: isLoading == true ? true : false,
        error: error,
        success: success,
      );
}
