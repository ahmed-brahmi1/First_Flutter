import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheUser(UserModel user);
  Future<UserModel?> getCachedUser();
  Future<void> cacheToken(String token);
  Future<String?> getCachedToken();
  Future<void> cacheRefreshToken(String refreshToken);
  Future<String?> getCachedRefreshToken();
  Future<void> cacheTokenExpiry(int? expiresAt);
  Future<int?> getCachedTokenExpiry();
  Future<void> clearCache();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String cachedUserKey = 'CACHED_USER';
  static const String cachedTokenKey = 'CACHED_TOKEN';
  static const String cachedRefreshTokenKey = 'CACHED_REFRESH_TOKEN';
  static const String cachedTokenExpiryKey = 'CACHED_TOKEN_EXPIRY';

  AuthLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheUser(UserModel user) async {
    try {
      final jsonString = json.encode(user.toJson());
      await sharedPreferences.setString(cachedUserKey, jsonString);
    } catch (e) {
      throw CacheException('Failed to cache user: $e');
    }
  }

  @override
  Future<UserModel?> getCachedUser() async {
    try {
      final jsonString = sharedPreferences.getString(cachedUserKey);
      if (jsonString == null) return null;
      final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
      return UserModel.fromJson(jsonMap);
    } catch (e) {
      throw CacheException('Failed to get cached user: $e');
    }
  }

  @override
  Future<void> cacheToken(String token) async {
    try {
      await sharedPreferences.setString(cachedTokenKey, token);
    } catch (e) {
      throw CacheException('Failed to cache token: $e');
    }
  }

  @override
  Future<String?> getCachedToken() async {
    try {
      return sharedPreferences.getString(cachedTokenKey);
    } catch (e) {
      throw CacheException('Failed to get cached token: $e');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await sharedPreferences.remove(cachedUserKey);
      await sharedPreferences.remove(cachedTokenKey);
      await sharedPreferences.remove(cachedRefreshTokenKey);
      await sharedPreferences.remove(cachedTokenExpiryKey);
    } catch (e) {
      throw CacheException('Failed to clear cache: $e');
    }
  }

  @override
  Future<void> cacheRefreshToken(String refreshToken) async {
    try {
      await sharedPreferences.setString(cachedRefreshTokenKey, refreshToken);
    } catch (e) {
      throw CacheException('Failed to cache refresh token: $e');
    }
  }

  @override
  Future<String?> getCachedRefreshToken() async {
    try {
      return sharedPreferences.getString(cachedRefreshTokenKey);
    } catch (e) {
      throw CacheException('Failed to get cached refresh token: $e');
    }
  }

  @override
  Future<void> cacheTokenExpiry(int? expiresAt) async {
    try {
      if (expiresAt == null) {
        await sharedPreferences.remove(cachedTokenExpiryKey);
      } else {
        await sharedPreferences.setInt(cachedTokenExpiryKey, expiresAt);
      }
    } catch (e) {
      throw CacheException('Failed to cache token expiry: $e');
    }
  }

  @override
  Future<int?> getCachedTokenExpiry() async {
    try {
      return sharedPreferences.getInt(cachedTokenExpiryKey);
    } catch (e) {
      throw CacheException('Failed to get cached token expiry: $e');
    }
  }
}
