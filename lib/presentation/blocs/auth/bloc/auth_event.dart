part of 'auth_bloc.dart';

sealed class AuthEvent {}

class LoginEmail extends AuthEvent {
  final String email;
  final String password;

  LoginEmail({
    required this.email,
    required this.password,
  });
}

class Logout extends AuthEvent {}

class SignUpEmail extends AuthEvent {
  final String email;
  final String password;
  final String username;

  SignUpEmail({
    required this.email,
    required this.password,
    required this.username,
  });
}

class CheckAuthStatus extends AuthEvent {}

class LoginGoogle extends AuthEvent {}
