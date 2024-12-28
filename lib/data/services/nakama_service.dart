import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gift_grab/domain/models/account/account_model.dart';
import 'package:gift_grab/domain/models/responses/authenticate_email_response.dart';
import 'package:gift_grab/domain/models/client_config.dart';

class NakamaService {
  final _dio = Dio();

  static const _isDevMode = true;

  static const _baseUrlDev = 'http://127.0.0.1:8000';
  static const _baseUrlProd = 'https://apikama.onrender.com/';

  String get _baseUrl => _isDevMode ? _baseUrlDev : _baseUrlProd;

  final _clientConfig = ClientConfig(
    host: _isDevMode ? '127.0.0.1' : '24.144.85.68',
    ssl: false,
    serverKey: 'defaultkey',
    grpcPort: 7351,
    httpPort: 7350,
  );

  Future<AuthenticateEmailResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final res = await _dio.post(
        '$_baseUrl/loginEmail?server_string=${_clientConfig.toString()}',
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

  Future<AccountModel> getAccount({
    required String sessionToken,
  }) async {
    try {
      final res = await _dio.get(
        '$_baseUrl/getAccount?server_string=${_clientConfig.toString()}&session_token=${sessionToken}',
      );

      final account = AccountModel.fromJson(res.data);

      return account;
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
      final res = await _dio.post(
        '$_baseUrl/signupEmail?server_string=${_clientConfig.toString()}',
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
