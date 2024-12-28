import 'package:gift_grab/domain/models/client_config.dart';

class AppConfig {
  static const isDevMode = true;

  static const baseUrlDev = 'http://127.0.0.1:8000';
  static const baseUrlProd = 'https://apikama.onrender.com/';

  static String get baseUrl => isDevMode ? baseUrlDev : baseUrlProd;

  static final clientConfig = ClientConfig(
    host: isDevMode ? '127.0.0.1' : '24.144.85.68',
    ssl: false,
    serverKey: 'defaultkey',
    httpPort: 7350,
  );
}
