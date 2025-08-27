import 'dart:convert';

import 'package:web_socket/web_socket.dart';

class WebSocketService {
  static final WebSocketService _instance = WebSocketService._internal();
  factory WebSocketService() => _instance;
  WebSocketService._internal();

  WebSocket? _socket;
  Stream<WebSocketEvent>? _broadcastStream;

  Stream<WebSocketEvent> get events {
    if (_broadcastStream == null) {
      throw Exception("WebSocket is not connected");
    }
    return _broadcastStream!;
  }

  Future<void> connect(String url) async {
    try {
      _socket = await WebSocket.connect(Uri.parse(url));
      _broadcastStream = _socket!.events.asBroadcastStream();
    } catch (e) {
      rethrow;
    }
  }

  void sendJson(Map<String, dynamic> data) {
    _socket?.sendText(jsonEncode(data));
  }

  void sendText(String message) {
    _socket?.sendText(message);
  }

  Future<void> close([int code = 1000, String reason = '']) async {
    await _socket?.close(code, reason);
    _broadcastStream = null; // Reset
  }
}
