import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class SocialAuthService {
  GoogleSignIn _googleSignIn;

  static final SocialAuthService _instance = SocialAuthService._internal();

  factory SocialAuthService({GoogleSignIn? googleSignIn}) {
    _instance._googleSignIn = googleSignIn ??
        GoogleSignIn(
          scopes: [
            'email',
            'https://www.googleapis.com/auth/contacts.readonly',
          ],
        );
    return _instance;
  }

  SocialAuthService._internal()
      : _googleSignIn = GoogleSignIn(
          scopes: [
            'email',
            'https://www.googleapis.com/auth/contacts.readonly',
          ],
        );

  Future<String?> getGoogleToken() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final googleAuth = await googleUser.authentication;
      return googleAuth.idToken;
    } catch (e) {
      debugPrint('Error getting Google token: $e');
      return null;
    }
  }

  Future<String?> getAppleToken() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final idToken = credential.identityToken;
      if (idToken == null) {
        debugPrint('Apple ID token is null');
        return null;
      }

      debugPrint('Apple ID Token received successfully');
      return idToken;
    } catch (e) {
      debugPrint('Error getting Apple token: $e');
      return null;
    }
  }
}
