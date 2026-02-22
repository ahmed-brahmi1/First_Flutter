import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../../config/constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/feeding_schedule_model.dart';

abstract class FeedingRemoteDataSource {
  Future<List<FeedingScheduleModel>> getFeedingLogs(String token);
  Future<void> triggerManualFeed(String token);
  Future<FeedingScheduleModel> setSchedule(String token, FeedingScheduleModel schedule);
}

class FeedingRemoteDataSourceImpl implements FeedingRemoteDataSource {
  final http.Client client;

  FeedingRemoteDataSourceImpl({required this.client});

  @override
  Future<List<FeedingScheduleModel>> getFeedingLogs(String token) async {
    try {
      final response = await client.get(
        Uri.parse('${AppConstants.baseUrl}${AppConstants.apiVersion}/feeding/logs'),
        headers: {'Authorization': 'Bearer $token'},
      ).timeout(AppConstants.connectionTimeout);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as List<dynamic>;
        return jsonData
            .map((item) => FeedingScheduleModel.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw ServerException(
          'Failed to get feeding logs: ${response.body}',
          response.statusCode,
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Network error: $e');
    }
  }

  @override
  Future<void> triggerManualFeed(String token) async {
    try {
      final response = await client.post(
        Uri.parse('${AppConstants.baseUrl}${AppConstants.apiVersion}/feeding/manual'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(AppConstants.connectionTimeout);

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ServerException(
          'Failed to trigger manual feed: ${response.body}',
          response.statusCode,
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Network error: $e');
    }
  }

  @override
  Future<FeedingScheduleModel> setSchedule(
    String token,
    FeedingScheduleModel schedule,
  ) async {
    try {
      final response = await client.post(
        Uri.parse('${AppConstants.baseUrl}${AppConstants.apiVersion}/feeding/schedule'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(schedule.toJson()),
      ).timeout(AppConstants.connectionTimeout);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;
        return FeedingScheduleModel.fromJson(jsonData);
      } else {
        throw ServerException(
          'Failed to set schedule: ${response.body}',
          response.statusCode,
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Network error: $e');
    }
  }
}

