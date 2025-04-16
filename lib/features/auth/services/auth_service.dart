import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  static final Dio _dio = Dio(BaseOptions(baseUrl: 'http://localhost:8082/api/auth')); // Update Base URL
  static final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  /// Login
  static Future<String?> login(String username, String password) async {
    try {
      final response = await _dio.post(
        '/login',
        data: {'username': username, 'password': password}, // Based on backend AuthController
      );
      if (response.statusCode == 200) {
        return response.data['token']; // Assuming the back-end sends a JWT token
      }
    } catch (e) {
      print('Login failed: $e');
    }
    return null;
  }

  /// Register
  static Future<bool> register(Map<String, dynamic> registerData) async {
    try {
      final response = await _dio.post(
        '/register',
        data: registerData, // Based on backend AuthController
      );
      return response.statusCode == 201; // Success if user is created
    } catch (e) {
      print('Registration failed: $e');
      return false;
    }
  }

  /// Get Token from Secure Storage
  static Future<String?> getToken() async {
    return await _secureStorage.read(key: 'token');
  }

  /// Save Token to Secure Storage
  static Future<void> saveToken(String token) async {
    await _secureStorage.write(key: 'token', value: token);
  }

  /// Remove Token from Secure Storage
  static Future<void> removeToken() async {
    await _secureStorage.delete(key: 'token');
  }
}