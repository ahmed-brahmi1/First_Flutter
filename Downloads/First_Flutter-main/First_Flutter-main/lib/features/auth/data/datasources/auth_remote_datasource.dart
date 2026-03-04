import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../../config/constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> register(String email, String password, String name);
  Future<void> logout(String token);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;

  AuthRemoteDataSourceImpl({required this.client});

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final response = await client
          .post(
            Uri.parse('${AppConstants.baseUrl}${AppConstants.apiVersion}/auth/login'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({
              'email': email,
              'password': password,
            }),
          )
          .timeout(AppConstants.connectionTimeout);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;
        // Réponse attendue : { "id": 1, "message": "Login successful", "email": "..." }
        return UserModel.fromLoginJson(jsonData);
      } else {
        final body = json.decode(response.body);
        final message = body['message'] ?? body['error'] ?? response.body;
        throw ServerException(
          'Identifiants incorrects: $message',
          response.statusCode,
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Erreur réseau lors de la connexion: $e');
    }
  }

  @override
  Future<UserModel> register(String email, String password, String name) async {
    try {
      final response = await client
          .post(
            Uri.parse('${AppConstants.baseUrl}${AppConstants.apiVersion}/auth/register'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({
              'email': email,
              'password': password,
              'name': name,
            }),
          )
          .timeout(AppConstants.connectionTimeout);

      if (response.statusCode == 201 || response.statusCode == 200) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;
        return UserModel.fromJson(jsonData);
      } else {
        final body = json.decode(response.body);
        final message = body['message'] ?? body['error'] ?? response.body;
        throw ServerException(
          'Inscription échouée: $message',
          response.statusCode,
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Erreur réseau lors de l\'inscription: $e');
    }
  }

  @override
  Future<void> logout(String token) async {
    try {
      final response = await client
          .post(
            Uri.parse('${AppConstants.baseUrl}${AppConstants.apiVersion}/auth/logout'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(AppConstants.connectionTimeout);

      if (response.statusCode != 200) {
        throw ServerException(
          'Déconnexion échouée: ${response.body}',
          response.statusCode,
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Erreur réseau lors de la déconnexion: $e');
    }
  }
}
