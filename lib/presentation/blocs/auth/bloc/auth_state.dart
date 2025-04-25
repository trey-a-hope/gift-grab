part of 'auth_bloc.dart';

class AuthState {
  final bool authenticated;
  final bool isLoading;
  final String? error;

  const AuthState({
    this.authenticated = false,
    this.isLoading = false,
    this.error,
  });

  AuthState copyWith({
    bool? authenticated,
    bool? isLoading,
    String? error,
  }) =>
      AuthState(
        authenticated: authenticated ?? this.authenticated,
        isLoading: isLoading == true ? true : false,
        error: error,
      );
}
