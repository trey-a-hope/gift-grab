import 'package:gift_grab/domain/repositories/i_social_auth_repository.dart';

class SocialAuthService {
  final ISocialAuthRepository _socialAuthRepository;

  SocialAuthService(this._socialAuthRepository);

  Future<String?> getGoogleToken() async {
    try {
      final token = await _socialAuthRepository.getGoogleToken();

      // Add any business logic here if needed
      if (token == null || token.isEmpty) {
        throw Exception('Failed to obtain Google authentication token');
      }

      return token;
    } catch (e) {
      // Handle business logic errors
      throw Exception('Google authentication failed: $e');
    }
  }

  Future<String?> getAppleToken() async {
    try {
      final token = await _socialAuthRepository.getAppleToken();

      // Add any business logic here if needed
      if (token == null || token.isEmpty) {
        throw Exception('Failed to obtain Apple authentication token');
      }

      return token;
    } catch (e) {
      // Handle business logic errors
      throw Exception('Apple authentication failed: $e');
    }
  }
}
