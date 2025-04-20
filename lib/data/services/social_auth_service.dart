import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SocialAuthService {
  final GoogleSignIn _googleSignIn;

  SocialAuthService({GoogleSignIn? googleSignIn})
      : _googleSignIn = googleSignIn ??
            GoogleSignIn(
              scopes: [
                'email',
                'https://www.googleapis.com/auth/contacts.readonly',
              ],
            ),
        super();

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
}
