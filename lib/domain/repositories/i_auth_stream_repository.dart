import 'package:equatable/equatable.dart';

abstract class IAuthStreamRepository {
  // State access
  AuthState get currentState;
  Stream<AuthState> get authStateStream;

  // Authentication methods
  Future<void> loginEmail(String email, String password);
  Future<void> signup(String email, String password, String username);
  Future<void> loginGoogle();
  Future<void> loginApple();
  Future<void> logout();
  Future<void> checkAuthStatus();

  // Cleanup
  void dispose();
}

class AuthState extends Equatable {
  final bool authenticated;
  final String? error;

  const AuthState({
    this.authenticated = false,
    this.error,
  });

  AuthState copyWith({
    bool? authenticated,
    String? error,
  }) =>
      AuthState(
        authenticated: authenticated ?? this.authenticated,
        error: error,
      );

  @override
  List<Object?> get props => [authenticated, error];
}
