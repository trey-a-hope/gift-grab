class ClientConfig {
  final String host;
  final bool ssl;
  final String serverKey;
  final int httpPort;

  ClientConfig({
    required this.host,
    required this.ssl,
    required this.serverKey,
    required this.httpPort,
  });

  Map toJson() => {
        "host": host,
        "ssl": ssl,
        "serverKey": serverKey,
        "httpPort": httpPort,
      };

  @override
  String toString() => [
        host,
        httpPort.toString(),
        ssl ? "1" : "0",
        serverKey,
      ].join(":");
}
