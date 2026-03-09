import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../config/constants.dart';
import '../errors/exceptions.dart';

import 'token_provider.dart';

/// Lightweight HTTP wrapper that
/// - prefixes requests with AppConstants.baseUrl + apiVersion
/// - attaches Authorization header from [TokenProvider] when no bearerToken is passed
/// - applies global timeouts
class ApiClient {
  final http.Client _client;
  final TokenProvider? _tokenProvider;

  ApiClient(this._client, {TokenProvider? tokenProvider}) : _tokenProvider = tokenProvider;

  Uri _buildUri(String path, {Map<String, String>? queryParameters}) {
    final base = AppConstants.baseUrl + AppConstants.apiVersion;
    return Uri.parse('$base$path').replace(queryParameters: queryParameters);
  }

  Future<String?> _resolveToken(String? bearerToken) async {
    if (bearerToken != null && bearerToken.isNotEmpty) return bearerToken;
    return _tokenProvider?.getToken();
  }

  Future<http.Response> get(
    String path, {
    Map<String, String>? headers,
    Map<String, String>? queryParameters,
    String? bearerToken,
  }) async {
    final token = await _resolveToken(bearerToken);
    final uri = _buildUri(path, queryParameters: queryParameters);
    final resolvedHeaders = _withAuth(headers, token);
    return _client
        .get(uri, headers: resolvedHeaders)
        .timeout(AppConstants.connectionTimeout);
  }

  Future<http.Response> post(
    String path, {
    Map<String, String>? headers,
    Object? body,
    Map<String, String>? queryParameters,
    String? bearerToken,
  }) async {
    final token = await _resolveToken(bearerToken);
    final uri = _buildUri(path, queryParameters: queryParameters);
    final resolvedHeaders = _withAuth(headers, token);
    return _client
        .post(uri, headers: resolvedHeaders, body: body)
        .timeout(AppConstants.connectionTimeout);
  }

  Future<http.Response> put(
    String path, {
    Map<String, String>? headers,
    Object? body,
    Map<String, String>? queryParameters,
    String? bearerToken,
  }) async {
    final token = await _resolveToken(bearerToken);
    final uri = _buildUri(path, queryParameters: queryParameters);
    final resolvedHeaders = _withAuth(headers, token);
    return _client
        .put(uri, headers: resolvedHeaders, body: body)
        .timeout(AppConstants.connectionTimeout);
  }

  Future<http.Response> patch(
    String path, {
    Map<String, String>? headers,
    Object? body,
    Map<String, String>? queryParameters,
    String? bearerToken,
  }) async {
    final token = await _resolveToken(bearerToken);
    final uri = _buildUri(path, queryParameters: queryParameters);
    final resolvedHeaders = _withAuth(headers, token);
    return _client
        .patch(uri, headers: resolvedHeaders, body: body)
        .timeout(AppConstants.connectionTimeout);
  }

  Future<http.Response> delete(
    String path, {
    Map<String, String>? headers,
    Object? body,
    Map<String, String>? queryParameters,
    String? bearerToken,
  }) async {
    final token = await _resolveToken(bearerToken);
    final uri = _buildUri(path, queryParameters: queryParameters);
    final resolvedHeaders = _withAuth(headers, token);
    return _client
        .delete(uri, headers: resolvedHeaders, body: body)
        .timeout(AppConstants.connectionTimeout);
  }

  Map<String, String> _withAuth(
    Map<String, String>? headers,
    String? bearerToken,
  ) {
    final resolved = <String, String>{
      'Content-Type': 'application/json',
      if (headers != null) ...headers,
    };

    if (bearerToken != null && bearerToken.isNotEmpty) {
      resolved['Authorization'] = 'Bearer $bearerToken';
    }

    return resolved;
  }

  /// Helper to decode JSON and throw on non-2xx status codes.
  /// Throws [AuthenticationException] for 401/403; [ServerException] otherwise.
  T decodeJsonOrThrow<T>(
    http.Response response, {
    T Function(Object json)? transform,
  }) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      final msg = response.body.isNotEmpty ? response.body : 'Request failed';
      if (response.statusCode == 401 || response.statusCode == 403) {
        throw AuthenticationException(msg);
      }
      throw ServerException(msg, response.statusCode);
    }

    final decoded = json.decode(response.body);
    if (transform != null) {
      return transform(decoded);
    }
    return decoded as T;
  }
}

