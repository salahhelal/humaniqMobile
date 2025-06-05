import 'package:flutter/material.dart';
import '../models/department.dart';
import '../services/api_service.dart';

class DepartmentProvider extends ChangeNotifier {
  List<Department> _departments = [];
  bool _loading = false;
  String? _error;
  final ApiService _apiService = ApiService();

  List<Department> get departments => _departments;
  bool get loading => _loading;
  String? get error => _error;

  Future<void> fetchDepartments() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final response = await _apiService.get('/api/rh/departments');
      _departments = (response.data as List)
          .map((json) => Department.fromJson(json))
          .toList();
    } catch (e) {
      _error = e.toString();
    }
    _loading = false;
    notifyListeners();
  }

  Future<void> addDepartment(String departmentName, String? id) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      // id can be null or string
      final path = id != null && id.isNotEmpty
          ? '/api/rh/departments/id}/$departmentName'
          : '/api/rh/departments/undefined/$departmentName';
      await _apiService.post(path);
      await fetchDepartments();
    } catch (e) {
      _error = e.toString();
    }
    _loading = false;
    notifyListeners();
  }

  Future<void> editDepartment(int id, String name, String head) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      await _apiService.put('/api/rh/departments/$id', data: {
        'name': name,
        'head': head,
      });
      await fetchDepartments();
    } catch (e) {
      _error = e.toString();
    }
    _loading = false;
    notifyListeners();
  }

  Future<void> deleteDepartment(int id) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      await _apiService.delete('/api/rh/department/$id');
      await fetchDepartments();
    } catch (e) {
      _error = e.toString();
    }
    _loading = false;
    notifyListeners();
  }
} 