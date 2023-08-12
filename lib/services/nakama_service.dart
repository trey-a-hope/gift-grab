import 'package:flutter/material.dart';
import 'package:nakama/nakama.dart';

enum NakamaAuthMethod {
  email,
  device,
}

class NakamaService {
  NakamaAuth auth = NakamaAuth();

  static const String _host = '127.0.0.1';
  static const bool _ssl = false;
  static const String _defaultkey = 'defaultkey';

  NakamaService() {
    // Set the Namaka client.
    getNakamaClient(
      host: _host,
      ssl: _ssl,
      serverKey: _defaultkey,
    );
  }
}

class NakamaAuth {
  Future createUserViaEmail({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      Session session = await getNakamaClient().authenticateEmail(
        email: email,
        password: password,
        username: username,
        create: true,
      );
      debugPrint('Nakama UID: ${session.userId}');
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<bool> authUserViaEmail({
    required String email,
    required String password,
  }) async {
    try {
      Session session = await getNakamaClient().authenticateEmail(
        email: email,
        password: password,
        create: false,
      );

      debugPrint('Nakama UID: ${session.userId}');

      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future createUserViaDevice({
    required String deviceId,
    required String username,
  }) async {
    try {
      Session session = await getNakamaClient().authenticateDevice(
        deviceId: deviceId,
        username: username,
        create: true,
      );

      debugPrint('Nakama UID: ${session.userId}');
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future authUserViaDevice({
    required String deviceId,
  }) async {
    try {
      Session session = await getNakamaClient().authenticateDevice(
        deviceId: deviceId,
        create: false,
      );

      debugPrint('Nakama UID: ${session.userId}');
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
