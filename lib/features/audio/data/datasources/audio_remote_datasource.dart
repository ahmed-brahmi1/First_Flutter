import 'dart:convert';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_client.dart';

abstract class AudioRemoteDataSource {
  Future<void> startTwoWayAudio();
  Future<void> sendVoiceCommand(String command);
  Future<void> stopAudio();
}

class AudioRemoteDataSourceImpl implements AudioRemoteDataSource {
  final ApiClient apiClient;

  AudioRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<void> startTwoWayAudio() async {
    try {
      await apiClient.post('/audio/start');
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Network error: $e');
    }
  }

  @override
  Future<void> sendVoiceCommand(String command) async {
    try {
      await apiClient.post(
        '/audio/command',
        body: json.encode({'command': command}),
      );
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Network error: $e');
    }
  }

  @override
  Future<void> stopAudio() async {
    try {
      await apiClient.post('/audio/stop');
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Network error: $e');
    }
  }
}
