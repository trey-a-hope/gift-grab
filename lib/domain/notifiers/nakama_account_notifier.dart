import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gift_grab/data/services/nakama_service.dart';
import 'package:gift_grab/domain/models/account/account_model.dart';
import 'package:gift_grab/domain/providers.dart';

class NakamaAccountNotifier extends AsyncNotifier<AccountModel> {
  final storage = const FlutterSecureStorage();

  @override
  FutureOr<AccountModel> build() async {
    try {
      await ref.read(Providers.nakamaAuthProvider.notifier).check();

      final token = (await storage.read(key: 'token'))!;

      debugPrint(token);

      final account = await NakamaService().getAccount(sessionToken: token);

      debugPrint('Account: ' + account.toString());

      return account;
    } catch (e) {
      throw Exception();
    }
  }
}
