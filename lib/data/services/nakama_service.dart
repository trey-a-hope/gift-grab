import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

class NakamaService {
  final _dio = Dio();

  void authenticateEmail() {
    _dio.post('', data: {});
  }

  Future<void> auth({required String username}) async {
    try {
      const proxy =
          'https://radiant-fortress-74557-a19cc3a8e264.herokuapp.com/';
      final nakamaEndpoint =
          'http://24.144.85.68:7350/v2/account/authenticate/email?username=$username';

      final proxyUrl = '$proxy$nakamaEndpoint';

      final Map<String, dynamic> requestBody = {
        "email": "trey.a.hope@gmail.com",
        "password": "Peachy4040",
        "create": true,
      };

      final encodedBody = json.encode(requestBody);

      final response = await http.post(
        Uri.parse(proxyUrl),
        body: encodedBody,
        headers: {
          'X-Requested-With': 'XMLHttpRequest',
          'Content-Type': 'application/json',
          'Authorization': 'Basic ${base64Encode(utf8.encode('defaultkey:'))}',
        },
      );

      if (response.statusCode != 200) {
        throw Exception(
          response.reasonPhrase ?? 'Could not log in at this time.',
        );
      }

      return;
    } catch (e) {
      throw Exception(e);
    }
  }
}
