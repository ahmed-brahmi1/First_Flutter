import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../../config/constants.dart';
import '../../../../core/errors/exceptions.dart';

abstract class AudioRemoteDataSource {
  Future<void> startTwoWayAudio(String token);
  Future<void> sendVoiceCommand(String token, String command);
  Future<void> stopAudio(String token);
}

class AudioRemoteDataSourceImpl implements AudioRemoteDataSource {
  final http.Client client;

  AudioRemoteDataSourceImpl({required this.client});

  @override
  Future<void> startTwoWayAudio(String token) async {
    try {
      final response = await client.post(
        Uri.parse('${AppConstants.baseUrl}${AppConstants.apiVersion}/audio/start'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(AppConstants.connectionTimeout);

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ServerException(
          'Failed to start audio: ${response.body}',
          response.statusCode,
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Network error: $e');
    }
  }

  @override
  Future<void> sendVoiceCommand(String token, String command) async {
    try {
      final response = await client.post(
        Uri.parse('${AppConstants.baseUrl}${AppConstants.apiVersion}/audio/command'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({'command': command}),
      ).timeout(AppConstants.connectionTimeout);

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ServerException(
          'Failed to send voice command: ${response.body}',
          response.statusCode,
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Network error: $e');
    }
  }

  @override
  Future<void> stopAudio(String token) async {
    try {
      final response = await client.post(
        Uri.parse('${AppConstants.baseUrl}${AppConstants.apiVersion}/audio/stop'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(AppConstants.connectionTimeout);

      if (response.statusCode != 200) {
        throw ServerException(
          'Failed to stop audio: ${response.body}',
          response.statusCode,
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Network error: $e');
    }
  }
}

