part of 'auth_bloc.dart';

abstract class AuthEvent {}

class LoginEmail extends AuthEvent {
  final String email;
  final String password;

  LoginEmail({
    required this.email,
    required this.password,
  });
}

class LoginGoogle extends AuthEvent {}

class LoginApple extends AuthEvent {}

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

class Logout extends AuthEvent {}

class CheckAuthStatus extends AuthEvent {}
