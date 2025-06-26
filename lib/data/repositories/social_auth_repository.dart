// data/repositories/social_auth_repository.dart
import 'package:flutter/material.dart';
import 'package:gift_grab/domain/repositories/i_social_auth_repository.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class SocialAuthRepository implements ISocialAuthRepository {
  final GoogleSignIn _googleSignIn;

  SocialAuthRepository({GoogleSignIn? googleSignIn})
      : _googleSignIn = googleSignIn ??
            GoogleSignIn(
              scopes: [
                'email',
                'https://www.googleapis.com/auth/contacts.readonly',
              ],
            );

  @override
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

  @override
  Future<String?> getAppleToken() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      return credential.identityToken;
    } catch (e) {
      debugPrint('Error getting Apple token: $e');
      return null;
    }
  }
}
