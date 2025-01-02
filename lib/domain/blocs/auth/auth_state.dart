part of 'auth_bloc.dart';

abstract class AuthState {
  final bool isAuthenticated;

  AuthState({required this.isAuthenticated});
}

class AuthInitial extends AuthState {
  AuthInitial() : super(isAuthenticated: false);
}

class AuthLoading extends AuthState {
  AuthLoading() : super(isAuthenticated: false);
}

class Authenticated extends AuthState {
  Authenticated() : super(isAuthenticated: true);
}

class Unauthenticated extends AuthState {
  Unauthenticated() : super(isAuthenticated: false);
}

class AuthError extends AuthState {
  final String message;

  AuthError({required this.message}) : super(isAuthenticated: false);
}
