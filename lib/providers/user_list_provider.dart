import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/api_service.dart';

class UserListProvider extends ChangeNotifier {
  List<User> _users = [];
  bool _loading = false;
  String? _error;
  final ApiService _apiService = ApiService();

  List<User> get users => _users;
  bool get loading => _loading;
  String? get error => _error;

  Future<void> fetchUsers() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final response = await _apiService.get('/api/rh/users');
      _users = (response.data as List)
          .map((json) => User.fromJson(json))
          .toList();
    } catch (e) {
      _error = e.toString();
    }
    _loading = false;
    notifyListeners();
  }
} 