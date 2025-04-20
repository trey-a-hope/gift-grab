part of 'auth_bloc.dart';

class AuthState {
  final bool authenticated;
  final bool isLoading;
  final String? error;

  const AuthState(this.authenticated, this.isLoading, this.error);

  AuthState copyWith({
    bool? authenticated,
    bool? isLoading,
    String? error,
  }) =>
      AuthState(
        authenticated ?? this.authenticated,
        isLoading == true ? true : false,
        error,
      );
}
