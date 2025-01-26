import 'package:flutter/material.dart';
import 'package:gift_grab/data/configuration/nakama_properties.dart';
import 'package:gift_grab/data/services/modal_service.dart';
import 'package:nakama/nakama.dart';

enum OnlineStatus {
  online('online'),
  offline('');

  final String status;

  const OnlineStatus(this.status);
}

class WebSocketService with WidgetsBindingObserver {
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

    // User is online after socket connects.
    _socket?.updateStatus(OnlineStatus.online.status);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        debugPrint('WebSocket: App resumed');
        _socket?.updateStatus(OnlineStatus.online.status);
        break;
      case AppLifecycleState.inactive:
        debugPrint('WebSocket: App inactive');
      case AppLifecycleState.paused:
        debugPrint('WebSocket: App paused');
      case AppLifecycleState.hidden:
        debugPrint('WebSocket: App hidden');
      case AppLifecycleState.detached:
        debugPrint('WebSocket: App detached');
        _socket?.updateStatus(OnlineStatus.offline.status);
        break;
    }
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _socket?.close();
    _socket = null;
  }

  bool get isConnected => _socket != null;
}
