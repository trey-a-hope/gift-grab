import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:nakama/nakama.dart';
import 'package:uuid/uuid.dart';

late NakamaBaseClient _nakamaClient;

late Session _session;

late String _deviceId;

final _inOneHour = DateTime.now().add(const Duration(hours: 1));

Future<void> _reauthenticate() async {
  // Check whether a session has expired or is close to expiry.
  if (_session.isExpired || _session.hasExpired(_inOneHour)) {
    try {
      // Attempt to refresh the existing session.
      debugPrint('Session expired. Attempting to refresh...');
      _session = await _nakamaClient.sessionRefresh(session: _session);
      debugPrint('isExpired:${_session.isExpired}');
    } catch (e) {
      // Couldn't refresh the session so reauthenticate.
      debugPrint(
          'Session refresh failed. Attempting to authenticate via device id...');
      _session = await _nakamaClient.authenticateDevice(deviceId: _deviceId);
    }
  }
}

class NakamaService {
  NakamaAuth auth = NakamaAuth();
  NakamaLeaderboard leaderboard = NakamaLeaderboard();

  final _host = '24.144.85.68'; // ipv4 address
  final _httpPort = 7351;

  NakamaService() {
    _nakamaClient = getNakamaClient(
      host: _host,
      ssl: false,
      serverKey: 'defaultkey',
      httpPort: _httpPort,
    );

    debugPrint('Nakama Service created.');
  }
}

class NakamaAuth {
  Future<Session> _authenticateEmail({
    required String email,
    required String password,
    required String? username,
    required bool create,
  }) async {
    try {
      final session = await _nakamaClient.authenticateEmail(
        email: email,
        password: password,
        username: username,
        create: create,
      );

      debugPrint('Nakama UID ${session.userId}');

      return session;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> createEmail({
    required String email,
    required String password,
    required String username,
  }) async {
    // Start session by authenitcating with email and password.
    _session = await _authenticateEmail(
      email: email,
      password: password,
      username: username,
      create: true,
    );

    await _linkDevice();
  }
}

Future<void> _linkDevice() async {
  final deviceInfoPlugin = DeviceInfoPlugin();

  if (Platform.isIOS) {
    // Get iOS device id.
    IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;
    if (iosInfo.identifierForVendor == null) {
      throw Exception('Cannot find iOS device ID.');
    }
    _deviceId = iosInfo.identifierForVendor!;
  } else if (Platform.isAndroid) {
    // Get Android device id.
    AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
    _deviceId = androidInfo.id;
  } else {
    // On web you could e.g. generate a UUID and store it into local storage
    const uuid = Uuid();
    _deviceId = uuid.v4();
  }

  debugPrint('Device ID: $_deviceId');

  // Link the users device id to their password auth for reauthentication later.
  await _nakamaClient.linkDevice(session: _session, deviceId: _deviceId);

  debugPrint('Successfully linked device id.');
}

class NakamaLeaderboard {
  static const String leaderboardName = 'weekly_leaderboard';

  Future<LeaderboardRecord> writeLeaderboardRecord({
    required int score,
  }) async {
    try {
      LeaderboardRecord leaderboardRecord =
          await _nakamaClient.writeLeaderboardRecord(
        session: _session,
        leaderboardName: leaderboardName,
        score: score,
      );

      return leaderboardRecord;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<LeaderboardRecord>> listLeaderboardRecords(int limit) async {
    try {
      await _reauthenticate();

      LeaderboardRecordList leaderboardRecordList =
          await _nakamaClient.listLeaderboardRecords(
        leaderboardName: leaderboardName,
        session: _session,
      );

      List<LeaderboardRecord> leaderboardRecords =
          leaderboardRecordList.records;

      return leaderboardRecords;
    } catch (e) {
      throw Exception(e);
    }
  }
}
