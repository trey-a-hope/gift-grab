import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gift_grab/data/services/app_config.dart';
import 'package:gift_grab/domain/models/account/account_model.dart';
import 'package:gift_grab/domain/models/authenticate_email_response.dart';
import 'package:gift_grab/domain/models/leaderboard/leaderboard_model.dart';

class NakamaServices {
  static final account = _NakamaAccountService();
  static final auth = _NakamaAuthService();
  static final leaderboard = _NakamaLeaderboardService();
}

final dio = Dio();

// Account
class _NakamaAccountService {
  Future<AccountModel> get({
    required String sessionToken,
  }) async {
    try {
      final res = await dio.get(
        '${AppConfig.baseUrl}/account?api_key=${AppConfig.apiKey}&session_token=$sessionToken',
      );

      final account = AccountModel.fromJson(res.data);

      return account;
    } catch (e) {
      throw Exception(e);
    }
  }
}

// Auth
class _NakamaAuthService {
  Future<AuthenticateEmailResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final res = await dio.post(
        '${AppConfig.baseUrl}/authenticate/email?api_key=${AppConfig.apiKey}',
        data: {
          "email": email,
          "password": password,
          "create": false,
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
        '${AppConfig.baseUrl}/authenticate/email?api_key=${AppConfig.apiKey}',
        data: {
          "email": email,
          "password": password,
          "create": true,
          "username": username,
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

// Leaderboard
class _NakamaLeaderboardService {
  static const _leaderboardId = 'weekly_leaderboard';

  Future<LeaderboardModel> get({
    required String sessionToken,
    required int limit,
    String? nextCursor,
  }) async {
    try {
      final res = await dio.get(
        '${AppConfig.baseUrl}/leaderboard?limit=$limit&session_token=$sessionToken&leaderboard_id=$_leaderboardId',
      );

      debugPrint(res.toString());

      return LeaderboardModel.fromJson(res.data);
    } catch (e) {
      throw Exception(e);
    }
  }
}
