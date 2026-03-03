import 'dart:convert';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_client.dart';

abstract class AuthRemoteDataSource {
  Future<Map<String, dynamic>> login(String email, String password);
  Future<Map<String, dynamic>> register(String email, String password, String name);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await apiClient.post(
        '/auth/login',
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      final jsonData =
          apiClient.decodeJsonOrThrow<Map<String, dynamic>>(response);
      return jsonData;
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Network error during login: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> register(
    String email,
    String password,
    String name,
  ) async {
    try {
      final response = await apiClient.post(
        '/auth/register',
        body: json.encode({
          'email': email,
          'password': password,
          'full_name': name,
        }),
      );

      final jsonData =
          apiClient.decodeJsonOrThrow<Map<String, dynamic>>(response);
      return jsonData;
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Network error during registration: $e');
    }
  }
}
