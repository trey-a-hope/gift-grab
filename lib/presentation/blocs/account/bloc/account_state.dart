part of 'account_bloc.dart';

class AccountState extends Equatable implements ErrorState {
  final Account? account;
  final FormzSubmissionStatus status;
  final bool isLoading;
  final String? error;
  final String? success;

  const AccountState({
    this.account,
    this.status = FormzSubmissionStatus.initial,
    this.isLoading = false,
    this.error,
    this.success,
  });

  AccountState copyWith({
    Account? account,
    FormzSubmissionStatus? status,
    bool? isLoading,
    String? error,
    String? success,
  }) =>
      AccountState(
        account: account ?? this.account,
        status: status ?? this.status,
        isLoading: isLoading == true ? true : false,
        error: error,
        success: success,
      );

  @override
  List<Object?> get props => [
        account,
        status,
        isLoading,
        error,
        success,
      ];
}
