import 'package:flutter/material.dart';
import '../models/payslip.dart';
import '../services/api_service.dart';

class PayslipProvider extends ChangeNotifier {
  List<Payslip> _payslips = [];
  bool _loading = false;
  String? _error;
  final ApiService _apiService = ApiService();

  List<Payslip> get payslips => _payslips;
  bool get loading => _loading;
  String? get error => _error;

  Future<void> fetchPayslips() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final response = await _apiService.get('/api/payslips');
      _payslips = (response.data as List)
          .map((json) => Payslip.fromJson(json))
          .toList();
    } catch (e) {
      _error = e.toString();
    }
    _loading = false;
    notifyListeners();
  }

  Future<void> filterPayslips({int? year, int? month}) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final response = await _apiService.get('/api/payslips', queryParameters: {
        if (year != null) 'year': year,
        if (month != null) 'month': month,
      });
      _payslips = (response.data as List)
          .map((json) => Payslip.fromJson(json))
          .toList();
    } catch (e) {
      _error = e.toString();
    }
    _loading = false;
    notifyListeners();
  }

  Future<void> downloadPayslip(int id) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      // Simulate download (implement actual download logic as needed)
      await _apiService.get('/api/payslips/$id/download');
    } catch (e) {
      _error = e.toString();
    }
    _loading = false;
    notifyListeners();
  }
} 