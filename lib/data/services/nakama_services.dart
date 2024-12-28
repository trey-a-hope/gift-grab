import 'package:dio/dio.dart';
import 'package:gift_grab/data/services/app_config.dart';
import 'package:gift_grab/domain/models/account/account_model.dart';
import 'package:gift_grab/domain/models/responses/authenticate_email_response.dart';

class NakamaServices {
  static final account = _NakamaAccountService();
  static final auth = _NakamaAuthService();
}

final dio = Dio();

// Account
class _NakamaAccountService {
  Future<AccountModel> get({
    required String sessionToken,
  }) async {
    try {
      final res = await dio.get(
        '${AppConfig.baseUrl}/account?server_string=${AppConfig.clientConfig.toString()}&session_token=${sessionToken}',
      );

      final account = AccountModel.fromJson(res.data);

      return account;
    } catch (e) {
      throw Exception(e);
    }
  }
}

class _NakamaAuthService {
  Future<AuthenticateEmailResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final res = await dio.post(
        '${AppConfig.baseUrl}/login-email?server_string=${AppConfig.clientConfig.toString()}',
        data: {
          "email": email,
          "password": password,
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

  Future<AuthenticateEmailResponse> signUp({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      final res = await dio.post(
        '${AppConfig.baseUrl}/signu-email?server_string=${AppConfig.clientConfig.toString()}',
        data: {
          "email": email,
          "password": password,
          'username': username,
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
