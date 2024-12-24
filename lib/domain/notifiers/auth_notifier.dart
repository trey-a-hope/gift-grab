import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthService {
  final storage = const FlutterSecureStorage();

  Future<bool> isAuthenticated() async {
    try {
      final token = await storage.read(key: 'token');
      if (token == null) return false;

      // Check if token is expired by decoding JWT
      final jwt = JwtDecoder.decode(token);
      final expiration = DateTime.fromMillisecondsSinceEpoch(jwt['exp'] * 1000);

      if (DateTime.now().isAfter(expiration)) {
        // Token expired, need to reauthenticate
        // Get stored credentials and reauthenticate
        final email = await storage.read(key: 'email');
        final password = await storage.read(key: 'password');

        if (email != null && password != null) {
          // final response = await NakamaService().authenticateEmail(
          //   email: email,
          //   password: password,
          //   username: 'trey.codez', // You might want to store this too
          //   create: false,
          // );
          // await saveTokens(response.token, response.refreshToken);
          return true;
        }
        return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> saveTokens(String token, String refreshToken) async {
    await storage.write(key: 'token', value: token);
    await storage.write(key: 'refreshToken', value: refreshToken);
  }
}
