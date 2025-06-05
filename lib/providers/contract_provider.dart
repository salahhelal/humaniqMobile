import 'package:flutter/material.dart';
import '../models/contract.dart';
import '../services/api_service.dart';

class ContractProvider extends ChangeNotifier {
  List<Contract> _contracts = [];
  bool _loading = false;
  String? _error;
  final ApiService _apiService = ApiService();

  List<Contract> get contracts => _contracts;
  bool get loading => _loading;
  String? get error => _error;

  Future<void> fetchContracts() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final response = await _apiService.get('/api/rh/contracts');
      _contracts = (response.data as List)
          .map((json) => Contract.fromJson(json))
          .toList();
    } catch (e) {
      _error = e.toString();
    }
    _loading = false;
    notifyListeners();
  }

  Future<void> addContract(Map<String, dynamic> contractData, int employeeId) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      await _apiService.post('/api/rh/contract/$employeeId', data: contractData);
      await fetchContracts();
    } catch (e) {
      _error = e.toString();
    }
    _loading = false;
    notifyListeners();
  }

  Future<void> editContract(int id, Map<String, dynamic> contractData) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      await _apiService.put('/api/rh/contract/$id', data: contractData);
      await fetchContracts();
    } catch (e) {
      _error = e.toString();
    }
    _loading = false;
    notifyListeners();
  }

  Future<void> archiveContract(int id) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      await _apiService.delete('/api/rh/contract/$id/archive');
      await fetchContracts();
    } catch (e) {
      _error = e.toString();
    }
    _loading = false;
    notifyListeners();
  }

  Future<void> deleteContract(int id) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      await _apiService.delete('/api/rh/contract/$id');
      await fetchContracts();
    } catch (e) {
      _error = e.toString();
    }
    _loading = false;
    notifyListeners();
  }
} 