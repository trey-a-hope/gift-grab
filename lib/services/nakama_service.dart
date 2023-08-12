import 'package:nakama/nakama.dart';

enum NakamaAuthMethod {
  email,
  device,
}

class NakamaService {
  late NakamaBaseClient _client;

  NakamaService() {
    _client = getNakamaClient(
      host: '127.0.0.1',
      ssl: false,
      serverKey: 'defaultkey',
    );
  }

  Future<Session> authenticateEmail({
    required String email,
    required String password,
    required String username,
  }) async {
    return await _client.authenticateEmail(
      email: email,
      password: password,
      username: username,
    );
  }

  Future<Session> authenticateDevice({
    required String deviceId,
    required String username,
  }) async {
    return await _client.authenticateDevice(
      deviceId: deviceId,
      username: username,
    );
  }
}
