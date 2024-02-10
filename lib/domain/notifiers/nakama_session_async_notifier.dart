import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nakama/nakama.dart';
import 'package:uuid/uuid.dart';

// Firebase authentication listener.
class NakamaSessionAsyncNotifier extends AsyncNotifier<Session?> {
  final _inOneHour = DateTime.now().add(const Duration(hours: 1));

  @override
  FutureOr<Session?> build() => null;

  Future signOut() async {
    //TODO: Sign out of session successfully.
    state = const AsyncData(null);
  }

  Future<void> _reauthenticate() async {
    final session = state.value!;
    // Check whether a session has expired or is close to expiry.
    if (session.isExpired || session.hasExpired(_inOneHour)) {
      try {
        // Attempt to refresh the existing session.
        debugPrint('Session expired. Attempting to refresh...');
        state = AsyncData(
          await getNakamaClient().sessionRefresh(
            session: session,
          ),
        );
        debugPrint('isExpired:${session.isExpired}');
      } catch (e) {
        // Couldn't refresh the session so reauthenticate.
        final deviceId = await _getDeviceId();
        debugPrint(
            'Session refresh failed. Attempting to authenticate via device id...');
        state = AsyncData(
          await getNakamaClient().authenticateDevice(deviceId: deviceId),
        );
      }
    }
  }

  Future authDevice() async {
    state = const AsyncLoading();

    try {
      final deviceId = await _getDeviceId();

      final session = await getNakamaClient().authenticateDevice(
        deviceId: deviceId,
        create: true,
      );

      // TODO: Expiry date is off by a factor of 1000. Fix this.
      // final expiryDate = DateTime.fromMicrosecondsSinceEpoch(
      //     session.expiresAt.microsecondsSinceEpoch * 1000);

      state = AsyncData(session);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  void authEmailPassword({
    required String email,
    required String password,
    required String username,
  }) async {
    state = const AsyncLoading();

    try {
      final session = await getNakamaClient().authenticateEmail(
        email: email,
        password: password,
        username: username,
        create: true,
      );

      _linkDeviceToSession();

      state = AsyncData(session);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  /// Returns the user's device id.
  Future<String> _getDeviceId() async {
    final deviceInfoPlugin = DeviceInfoPlugin();

    if (Platform.isIOS) {
      // Get iOS device id.
      IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;
      if (iosInfo.identifierForVendor == null) {
        throw Exception('Cannot find iOS device ID.');
      }
      return iosInfo.identifierForVendor!;
    } else if (Platform.isAndroid) {
      // Get Android device id.
      AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
      return androidInfo.id;
    } else {
      // On web you could e.g. generate a UUID and store it into local storage
      const uuid = Uuid();
      return uuid.v4();
    }
  }

  /// Connects a user's device id to their session.
  Future<void> _linkDeviceToSession() async {
    String deviceId = await _getDeviceId();

    debugPrint('Device ID: $deviceId');

    // Link the users device id to their password auth for reauthentication later.
    await getNakamaClient().linkDevice(
      session: state.value!,
      deviceId: deviceId,
    );

    debugPrint('Successfully linked device id.');
  }
}
