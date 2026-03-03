import 'dart:convert';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/feeding_schedule_model.dart';

abstract class FeedingRemoteDataSource {
  Future<List<FeedingScheduleModel>> getFeedingLogs();
  Future<void> triggerManualFeed();
  Future<FeedingScheduleModel> setSchedule(FeedingScheduleModel schedule);
  Future<FeedingScheduleModel> updateSchedule(String id, FeedingScheduleModel schedule);
  Future<void> deleteSchedule(String id);
}

class FeedingRemoteDataSourceImpl implements FeedingRemoteDataSource {
  final ApiClient apiClient;

  FeedingRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<FeedingScheduleModel>> getFeedingLogs() async {
    try {
      final response = await apiClient.get('/feeding-schedule');
      final list = apiClient.decodeJsonOrThrow<List<dynamic>>(response);
      return list
          .map((e) => FeedingScheduleModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Network error: $e');
    }
  }

  @override
  Future<void> triggerManualFeed() async {
    throw ServerException('Manual feed trigger not supported by backend', 501);
  }

  @override
  Future<FeedingScheduleModel> setSchedule(FeedingScheduleModel schedule) async {
    try {
      final body = schedule.toJson();
      body.remove('id');
      final response = await apiClient.post(
        '/feeding-schedule',
        body: json.encode(body),
      );
      final jsonData = apiClient.decodeJsonOrThrow<Map<String, dynamic>>(response);
      return FeedingScheduleModel.fromJson(jsonData);
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Network error: $e');
    }
  }

  @override
  Future<FeedingScheduleModel> updateSchedule(
    String id,
    FeedingScheduleModel schedule,
  ) async {
    try {
      final body = schedule.toJson();
      body.remove('id');
      final response = await apiClient.patch(
        '/feeding-schedule/$id',
        body: json.encode(body),
      );
      final jsonData = apiClient.decodeJsonOrThrow<Map<String, dynamic>>(response);
      return FeedingScheduleModel.fromJson(jsonData);
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Network error: $e');
    }
  }

  @override
  Future<void> deleteSchedule(String id) async {
    try {
      await apiClient.delete('/feeding-schedule/$id');
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Network error: $e');
    }
  }
}
