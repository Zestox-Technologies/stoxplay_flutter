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

  Future<void> close() async {
    final socket = _socket;
    _socket = null; // mark as closed early to avoid double-close races

    if (socket == null) return;

    try {
      await socket.close();
    } on WebSocketConnectionClosed {
      // already closed by server or earlier — just ignore
    } catch (e, st) {
        print('Error while closing WebSocket: $e');
    }
  }
}
