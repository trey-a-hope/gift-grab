import 'package:dio/dio.dart';
import 'package:gift_grab/domain/models/authenticate_email_response.dart';

class NakamaService {
  final _dio = Dio();

  final bool _isDevMode = true;

  static const _baseUrlDev = 'http://127.0.0.1:8000';
  static const _baseUrlProd = 'https://gift-grab-api.onrender.com';

  String get _baseUrl => _isDevMode ? _baseUrlDev : _baseUrlProd;

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
          'email': email,
          'password': password,
          'username': username,
          'create': create,
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
