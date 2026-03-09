import 'dart:async';

import 'package:socket_io_client/socket_io_client.dart' as io;

import '../../config/constants.dart';
import 'token_provider.dart';

/// Payload shape emitted by smart-pet-backend SocketGateway (device-data event).
class DeviceDataEvent {
  final String deviceId;
  final String timestamp;
  final Map<String, dynamic> data;

  DeviceDataEvent({
    required this.deviceId,
    required this.timestamp,
    required this.data,
  });

  factory DeviceDataEvent.fromJson(Map<String, dynamic> json) {
    return DeviceDataEvent(
      deviceId: json['device_id'] as String? ?? '',
      timestamp: json['timestamp'] as String? ?? '',
      data: (json['data'] is Map<String, dynamic>)
          ? json['data'] as Map<String, dynamic>
          : <String, dynamic>{},
    );
  }
}

/// Connects to smart-pet-backend Socket.IO gateway and streams [DeviceDataEvent].
/// Backend: namespace '/', auth via handshake.auth.token; emits 'device-data'.
class DeviceDataSocket {
  DeviceDataSocket({
    required TokenProvider tokenProvider,
    String? baseUrl,
  })  : _tokenProvider = tokenProvider,
        _baseUrl = baseUrl ?? AppConstants.baseUrl;

  final TokenProvider _tokenProvider;
  final String _baseUrl;

  io.Socket? _socket;
  final _deviceDataController = StreamController<DeviceDataEvent>.broadcast();

  Stream<DeviceDataEvent> get deviceDataStream => _deviceDataController.stream;

  bool get isConnected => _socket?.connected ?? false;

  Future<void> connect() async {
    if (_socket?.connected == true) return;
    final token = await _tokenProvider.getToken();
    if (token == null || token.isEmpty) {
      throw StateError('Cannot connect DeviceDataSocket: no token');
    }
    _socket = io.io(
      _baseUrl,
      <String, dynamic>{
        'transports': ['websocket'],
        'auth': {'token': token},
        'reconnection': true,
      },
    );
    _socket!.on('device-data', (dynamic payload) {
      if (payload is Map<String, dynamic>) {
        _deviceDataController.add(DeviceDataEvent.fromJson(payload));
      }
    });
    _socket!.onConnectError((data) => _deviceDataController.addError(data));
    _socket!.onError((data) => _deviceDataController.addError(data));
  }

  void disconnect() {
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
  }

  void dispose() {
    disconnect();
    _deviceDataController.close();
  }
}
