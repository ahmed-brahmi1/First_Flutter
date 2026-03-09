import 'dart:convert';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_client.dart';
import 'package:smartpet/features/devices/data/models/device_model.dart';
import '../models/pet_model.dart';

abstract class PetRemoteDataSource {
  Future<List<PetModel>> getPets();
  Future<PetModel> getPet(String id);
  Future<PetModel> createPet(Map<String, dynamic> body);
  Future<PetModel> updatePet(String id, Map<String, dynamic> body);
  Future<void> deletePet(String id);
  Future<List<DeviceModel>> getPetDevices(String petId);
  Future<DeviceModel> linkDevice(String petId, String deviceId);
  Future<void> unlinkDevice(String petId, String deviceId);
}

class PetRemoteDataSourceImpl implements PetRemoteDataSource {
  final ApiClient apiClient;

  PetRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<PetModel>> getPets() async {
    final response = await apiClient.get('/pet');
    final list = apiClient.decodeJsonOrThrow<List<dynamic>>(response);
    return list.map((e) => PetModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<PetModel> getPet(String id) async {
    final response = await apiClient.get('/pet/$id');
    final json = apiClient.decodeJsonOrThrow<Map<String, dynamic>>(response);
    return PetModel.fromJson(json);
  }

  @override
  Future<PetModel> createPet(Map<String, dynamic> body) async {
    final response = await apiClient.post('/pet', body: json.encode(body));
    final data = apiClient.decodeJsonOrThrow<Map<String, dynamic>>(response);
    return PetModel.fromJson(data);
  }

  @override
  Future<PetModel> updatePet(String id, Map<String, dynamic> body) async {
    final response = await apiClient.patch('/pet/$id', body: json.encode(body));
    final data = apiClient.decodeJsonOrThrow<Map<String, dynamic>>(response);
    return PetModel.fromJson(data);
  }

  @override
  Future<void> deletePet(String id) async {
    await apiClient.delete('/pet/$id');
  }

  @override
  Future<List<DeviceModel>> getPetDevices(String petId) async {
    final response = await apiClient.get('/pet/$petId/devices');
    final list = apiClient.decodeJsonOrThrow<List<dynamic>>(response);
    return list.map((e) => DeviceModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<DeviceModel> linkDevice(String petId, String deviceId) async {
    final response = await apiClient.post(
      '/pet/$petId/devices/link',
      body: json.encode({'device_id': deviceId}),
    );
    final data = apiClient.decodeJsonOrThrow<Map<String, dynamic>>(response);
    return DeviceModel.fromJson(data);
  }

  @override
  Future<void> unlinkDevice(String petId, String deviceId) async {
    await apiClient.delete('/pet/$petId/devices/$deviceId');
  }
}
