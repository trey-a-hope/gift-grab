import 'package:gift_grab/domain/entities/auth_state.dart';

abstract class IAuthStreamRepository {
  AuthState get currentState;
  Stream<AuthState> get authStateStream;

  Future<void> loginEmail(String email, String password);
  Future<void> logout();
  Future<void> checkAuthStatus();
  Future<void> signup(String email, String password, String username);
  Future<void> loginGoogle();
  Future<void> loginApple();

  void dispose();
}
