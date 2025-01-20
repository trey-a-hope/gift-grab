class NakamaProperties {
  static late final String host;
  static const bool ssl = false;
  static const int httpPort = 7350;
  static late final String serverKey;

  static void initialize({
    required bool isDev,
    required String key,
  }) {
    host = isDev ? '127.0.0.1' : '24.144.85.68';
    serverKey = key;
  }
}
