import 'package:flutter/foundation.dart';
import 'package:quickslot_app/core/constants/app_constants.dart';
import 'package:quickslot_app/features/venues/domain/entities/slot_update_event.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

enum RealtimeConnectionStatus { disconnected, connecting, connected, error }

class SlotRealtimeService {
  SlotRealtimeService({String? serverUrl})
      : _serverUrl = serverUrl ?? AppConstants.baseUrl;

  final String _serverUrl;
  io.Socket? _socket;

  final ValueNotifier<RealtimeConnectionStatus> connectionStatus =
      ValueNotifier(RealtimeConnectionStatus.disconnected);

  void Function(SlotUpdateEvent event)? onSlotUpdated;
  VoidCallback? onReconnected;

  bool _wasDisconnected = false;

  void connect() {
    if (_socket != null) {
      return;
    }

    connectionStatus.value = RealtimeConnectionStatus.connecting;

    _socket = io.io(
      _serverUrl,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .enableReconnection()
          .setReconnectionAttempts(5)
          .setReconnectionDelay(2000)
          .build(),
    );

    _socket!
      ..onConnect(_handleConnect)
      ..onDisconnect(_handleDisconnect)
      ..onConnectError(_handleConnectError)
      ..onError(_handleConnectError)
      ..on('slot-updated', _handleSlotUpdated)
      ..connect();
  }

  void disconnect() {
    _socket?.dispose();
    _socket = null;
    _wasDisconnected = false;
    connectionStatus.value = RealtimeConnectionStatus.disconnected;
  }

  void _handleConnect(_) {
    connectionStatus.value = RealtimeConnectionStatus.connected;

    if (_wasDisconnected) {
      onReconnected?.call();
    }

    _wasDisconnected = false;
  }

  void _handleDisconnect(_) {
    _wasDisconnected = true;
    connectionStatus.value = RealtimeConnectionStatus.disconnected;
  }

  void _handleConnectError(_) {
    connectionStatus.value = RealtimeConnectionStatus.error;
  }

  void _handleSlotUpdated(dynamic data) {
    if (data is! Map) {
      return;
    }

    final event = SlotUpdateEvent.fromJson(
      Map<String, dynamic>.from(data),
    );
    onSlotUpdated?.call(event);
  }
}
