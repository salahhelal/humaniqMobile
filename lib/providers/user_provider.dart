import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/api_service.dart';
import 'package:dio/dio.dart';

class UserProvider extends ChangeNotifier {
  User? _user;
  final ApiService _apiService = ApiService();
  bool _loading = false;
  String? _error;

  User? get user => _user;
  bool get loading => _loading;
  String? get error => _error;

  Future<void> fetchProfile() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final response = await _apiService.get('/api/rh/users/profile');
      _user = User.fromJson(response.data);
    } catch (e) {
      _error = e.toString();
    }
    _loading = false;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final loginPayload = {
        'username': email,
        'password': password,
      };
      print('Login request payload: ' + loginPayload.toString());
      final response = await _apiService.post('/api/auth/login', data: loginPayload);
      print('Login response: ' + response.data.toString());
      final token = response.data['token'];
      await _apiService.saveToken(token);
      await fetchProfile();
      return true;
    } catch (e) {
      if (e is DioException) {
        print('Login error response: ' + (e.response?.data?.toString() ?? e.toString()));
      } else {
        print('Login error: ' + e.toString());
      }
      _error = e.toString();
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _apiService.clearToken();
    _user = null;
    notifyListeners();
  }
} 