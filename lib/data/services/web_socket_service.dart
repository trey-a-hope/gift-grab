import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gift_grab/data/configuration/nakama_properties.dart';
import 'package:gift_grab/data/services/modal_service.dart';
import 'package:nakama/nakama.dart';

class WebSocketService with WidgetsBindingObserver {
  final _storage = const FlutterSecureStorage();

  static WebSocketService? _instance;
  NakamaWebsocketClient? _socket;

  NakamaWebsocketClient? get socket => _socket;

  factory WebSocketService() {
    _instance ??= WebSocketService._internal();
    return _instance!;
  }

  WebSocketService._internal() {
    WidgetsBinding.instance.addObserver(this);
  }

  Future<void> initialize(String token) async {
    _socket = NakamaWebsocketClient.init(
      host: NakamaProperties.host,
      ssl: NakamaProperties.ssl,
      token: token,
      onError: (dynamic error) {
        ModalService.showError(title: error.toString());
        debugPrint(error.toString());
      },
      onDone: () => debugPrint('NakamaWebsocketClient.init done.'),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.detached:
        _socket?.close();
        debugPrint('WebSocket: App detached');
        break;
      case AppLifecycleState.inactive:
        debugPrint('WebSocket: App inactive');
        break;
      case AppLifecycleState.paused:
        debugPrint('WebSocket: App paused');
        break;
      case AppLifecycleState.resumed:
        _reconnectIfNeeded();
        debugPrint('WebSocket: App resumed');
        break;
      case AppLifecycleState.hidden:
        debugPrint('WebSocket: App hidden');
        break;
    }
  }

  Future<void> _reconnectIfNeeded() async {
    if (_socket == null || !isConnected) {
      final token = await _storage.read(key: 'token');
      if (token != null) {
        initialize(token);
      }
    }
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _socket?.close();
    _socket = null;
  }

  bool get isConnected => _socket != null;
}
