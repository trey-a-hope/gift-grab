import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

/// Provider used to check if the user is authenticated.
class NakamaAuthNotifier extends AsyncNotifier<bool> {
  final storage = const FlutterSecureStorage();

  @override
  FutureOr<bool> build() async => isAuthenticated();

  Future<void> check() async => state = AsyncData(await isAuthenticated());

  Future<bool> isAuthenticated() async {
    try {
      final refreshToken = await storage.read(key: 'refreshToken');
      if (refreshToken == null) {
        return false;
      }

      // Check if token is expired by decoding JWT
      final jwt = JwtDecoder.decode(refreshToken);
      final expiration = DateTime.fromMillisecondsSinceEpoch(jwt['exp'] * 1000);

      if (DateTime.now().isAfter(expiration)) {
        // TODO: Token expired, need to reauthenticate automatically.
        return false;
      }

      // Save the uid of the jwt.
      final uid = jwt['uid'];
      await storage.write(value: 'uid', key: uid);
      debugPrint('UID: $uid');

      return true;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future logout() async {
    await storage.delete(key: 'token');
    await storage.delete(key: 'refreshToken');
    await storage.delete(key: 'uid');
    // Set authenticated state to false.
    state = const AsyncData(false);
  }
}
