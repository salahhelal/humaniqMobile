import 'package:flutter/material.dart';
import '../models/leave_request.dart';
import '../services/api_service.dart';
import 'package:dio/dio.dart';

class LeaveRequestProvider extends ChangeNotifier {
  List<LeaveRequest> _leaveRequests = [];
  bool _loading = false;
  String? _error;
  final ApiService _apiService = ApiService();

  List<LeaveRequest> get leaveRequests => _leaveRequests;
  bool get loading => _loading;
  String? get error => _error;

  Future<void> fetchLeaveRequests(String username) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final response = await _apiService.get('/api/holiday/username/$username');
      _leaveRequests = (response.data as List)
          .map((json) => LeaveRequest.fromJson(json))
          .toList();
    } catch (e) {
      _error = e.toString();
    }
    _loading = false;
    notifyListeners();
  }

  Future<void> submitLeaveRequest(Map<String, dynamic> requestData, String email, [String? filePath]) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final formData = FormData.fromMap({
        ...requestData,
        'email': email,
        if (filePath != null && filePath.isNotEmpty)
          'file': await MultipartFile.fromFile(filePath),
      });
      await _apiService.post('/api/holiday', data: formData);
      await fetchLeaveRequests(email);
    } catch (e) {
      _error = e.toString();
    }
    _loading = false;
    notifyListeners();
  }
} 