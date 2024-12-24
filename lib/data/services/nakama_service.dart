import 'package:dio/dio.dart';
import 'package:gift_grab/domain/models/authenticate_email_response.dart';
import 'package:gift_grab/domain/models/client_config.dart';

class NakamaService {
  final _dio = Dio();

  final bool _isDevMode = false;

  static const _baseUrlDev = 'http://127.0.0.1:8000';
  static const _baseUrlProd = 'https://gift-grab-api.onrender.com';

  String get _baseUrl => _isDevMode ? _baseUrlDev : _baseUrlProd;

  final _clientConfig = ClientConfig(
    host: '24.144.85.68',
    ssl: false,
    serverKey: 'defaultkey',
    grpcPort: 7351,
    httpPort: 7350,
  );

  Future<AuthenticateEmailResponse> authenticateEmail({
    required String email,
    required String password,
    required String username,
    required bool create,
  }) async {
    try {
      final res = await _dio.post(
        '$_baseUrl/authenticateEmail',
        data: {
          "client": _clientConfig.toJson(),
          "request": {
            "email": email,
            "password": password,
            "username": username,
            "create": true
          }
        },
      );

      return AuthenticateEmailResponse(
        token: res.data['token'],
        refreshToken: res.data['refresh_token'],
      );
    } catch (e) {
      throw Exception(e);
    }
  }
}
