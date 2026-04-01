import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/models/user_model.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/secure_storage.dart';

final authProvider = AsyncNotifierProvider<AuthNotifier, UserModel?>(() {
  return AuthNotifier();
});

class AuthNotifier extends AsyncNotifier<UserModel?> {
  @override
  FutureOr<UserModel?> build() async {
    return _checkAuth();
  }

  Future<UserModel?> _checkAuth() async {
    try {
      final token = await SecureStorage.getToken();
      if (token == null) {
        return null;
      }
      
      final res = await ApiClient.instance.get(ApiEndpoints.me);
      return UserModel.fromJson(res.data);
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 401) {
        // Token expired/invalid, logout silent.
        await SecureStorage.deleteAll();
      }
      return null;
    }
  }

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    try {
      final res = await ApiClient.instance.post(ApiEndpoints.login, data: {
        'email': email,
        'password': password,
      });

      final String token = res.data['token'];
      final UserModel user = UserModel.fromJson(res.data['user']);
      
      await SecureStorage.saveToken(token);
      state = AsyncData(user);
    } on DioException catch (e) {
      state = AsyncError(ApiException.fromDioException(e), StackTrace.current);
      rethrow; // Rethrow to let the UI catch and show SnackBar
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  Future<void> register(String fullName, String email, String password, String role) async {
    state = const AsyncLoading();
    try {
      final res = await ApiClient.instance.post(ApiEndpoints.register, data: {
        'full_name': fullName,
        'email': email,
        'password': password,
        'role': role,
      });

      final String token = res.data['token'];
      final UserModel user = UserModel.fromJson(res.data['user']);
      
      await SecureStorage.saveToken(token);
      state = AsyncData(user);
    } on DioException catch (e) {
      state = AsyncError(ApiException.fromDioException(e), StackTrace.current);
      rethrow;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  Future<void> logout() async {
    await SecureStorage.deleteAll();
    state = const AsyncData(null);
  }
}
