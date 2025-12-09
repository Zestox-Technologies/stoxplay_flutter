import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:stoxplay/core/local_storage/storage_service.dart';
import 'package:stoxplay/core/network/api_urls.dart';
import 'package:stoxplay/core/network/ws_service.dart';
import 'package:stoxplay/features/home_page/data/models/live_stock_model.dart';
import 'package:stoxplay/utils/constants/db_keys.dart';
import 'package:web_socket/web_socket.dart';

/// Manages WebSocket connection and events for the Battleground page.
///
/// This class encapsulates all WebSocket-related logic including:
/// - Connection lifecycle management
/// - Team subscription
/// - Score update event handling
/// - Resource cleanup
class BattlegroundWebSocketManager {
  final WebSocketService _ws = WebSocketService();
  final ValueNotifier<ScoreUpdatePayload?> scoreNotifier = ValueNotifier(null);
  StreamSubscription? _eventSubscription;

  /// Connects to WebSocket and subscribes to team updates
  ///
  /// [teamId] - The team ID to subscribe to
  Future<void> connect(String teamId) async {
    try {
      final token = StorageService().read<String>(DBKeys.userTokenKey);
      
      await _ws.connect(ApiUrls.wsUrl);
      
      // Subscribe to team updates
      _ws.sendJson({
        "type": "SUBSCRIBE_TEAM",
        "token": token,
        "userTeamId": teamId,
      });

      // Listen to WebSocket events
      _eventSubscription = _ws.events.listen(_handleWebSocketEvent);
    } catch (error, stackTrace) {
      if (kDebugMode) {
        print('WebSocket connection error: $error');
        print(stackTrace);
      }
    }
  }

  /// Handles incoming WebSocket events
  void _handleWebSocketEvent(WebSocketEvent event) {
    switch (event) {
      case TextDataReceived(:final text):
        _handleTextData(text);
        break;
      case CloseReceived():
        if (kDebugMode) {
          print('WebSocket connection closed');
        }
        break;
      case BinaryDataReceived():
        // Binary data not currently handled
        break;
    }
  }

  /// Handles text data received from WebSocket
  void _handleTextData(String text) {
    try {
      final decoded = jsonDecode(text);
      final type = decoded['type'];

      if (type == 'SCORE_UPDATE' || type == 'HISTORICAL_SCORE') {
        final payload = ScoreUpdatePayload.fromJson(decoded['payload']);
        if (payload.liveStocks.isNotEmpty) {
          scoreNotifier.value = payload;
        }
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error parsing WebSocket data: $error');
      }
    }
  }

  /// Closes the WebSocket connection and cleans up resources
  void dispose() {
    _eventSubscription?.cancel();
    _ws.close();
    scoreNotifier.dispose();
  }
}
