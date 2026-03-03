import 'dart:convert';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/device_model.dart';

abstract class DeviceRemoteDataSource {
  Future<List<DeviceModel>> getDevices();
  Future<DeviceModel> getDevice(String id);
  Future<DeviceModel> claimDevice(
    String deviceId,
    String activationSecret, {
    String? petId,
  });
  Future<DeviceModel> createDevice(Map<String, dynamic> body);
  Future<DeviceModel> updateDevice(String id, Map<String, dynamic> body);
  Future<void> deleteDevice(String id);
}

class DeviceRemoteDataSourceImpl implements DeviceRemoteDataSource {
  final ApiClient apiClient;

  DeviceRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<DeviceModel>> getDevices() async {
    final response = await apiClient.get('/device');
    final list = apiClient.decodeJsonOrThrow<List<dynamic>>(response);
    return list.map((e) => DeviceModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<DeviceModel> getDevice(String id) async {
    final response = await apiClient.get('/device/$id');
    final json = apiClient.decodeJsonOrThrow<Map<String, dynamic>>(response);
    return DeviceModel.fromJson(json);
  }

  @override
  Future<DeviceModel> claimDevice(
    String deviceId,
    String activationSecret, {
    String? petId,
  }) async {
    final body = <String, dynamic>{
      'device_id': deviceId,
      'activation_secret': activationSecret,
    };
    if (petId != null) body['pet_id'] = petId;
    final response = await apiClient.post('/device/claim', body: json.encode(body));
    final data = apiClient.decodeJsonOrThrow<Map<String, dynamic>>(response);
    return DeviceModel.fromJson(data);
  }

  @override
  Future<DeviceModel> createDevice(Map<String, dynamic> body) async {
    final response = await apiClient.post('/device', body: json.encode(body));
    final data = apiClient.decodeJsonOrThrow<Map<String, dynamic>>(response);
    return DeviceModel.fromJson(data);
  }

  @override
  Future<DeviceModel> updateDevice(String id, Map<String, dynamic> body) async {
    final response = await apiClient.patch('/device/$id', body: json.encode(body));
    final data = apiClient.decodeJsonOrThrow<Map<String, dynamic>>(response);
    return DeviceModel.fromJson(data);
  }

  @override
  Future<void> deleteDevice(String id) async {
    await apiClient.delete('/device/$id');
  }
}
