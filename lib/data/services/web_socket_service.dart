import 'package:flutter/material.dart';
import 'package:gift_grab/data/configuration/nakama_properties.dart';
import 'package:gift_grab/data/services/modal_service.dart';
import 'package:nakama/nakama.dart';

class WebSocketService {
  static WebSocketService? _instance;
  NakamaWebsocketClient? _socket;

  NakamaWebsocketClient? get socket => _socket;

  factory WebSocketService() {
    _instance ??= WebSocketService._internal();
    return _instance!;
  }

  WebSocketService._internal();

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

  void dispose() {
    _socket?.close();
    _socket = null;
  }

  bool get isConnected => _socket != null;
}
