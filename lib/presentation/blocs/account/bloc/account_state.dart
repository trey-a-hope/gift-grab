part of 'account_bloc.dart';

class AccountState extends Equatable implements ErrorState {
  final Account? account;
  final FormzSubmissionStatus status;
  final String? success;
  final bool isLoading;
  final String? error;

  const AccountState({
    this.account,
    this.status = FormzSubmissionStatus.initial,
    this.success,
    this.isLoading = true,
    this.error,
  });

  AccountState copyWith({
    Account? account,
    FormzSubmissionStatus? status,
    String? success,
    bool? isLoading,
    String? error,
  }) =>
      AccountState(
        account: account ?? this.account,
        status: status ?? this.status,
        success: success,
        isLoading: isLoading == true ? true : false,
        error: error,
      );

  @override
  List<Object?> get props => [
        account,
        status,
        success,
        isLoading,
        error,
      ];
}
