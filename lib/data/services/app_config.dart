import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static const isDevMode = false;

  static late String apiKey;

  static Future<void> init() async {
    await dotenv.load();

    apiKey =
        isDevMode ? dotenv.env['API_KEY_DEV']! : dotenv.env['API_KEY_PROD']!;
  }

  static const baseUrlDev = 'http://127.0.0.1:8000';
  static const baseUrlProd = 'https://apikama.onrender.com';

  static String get baseUrl => isDevMode ? baseUrlDev : baseUrlProd;
}
