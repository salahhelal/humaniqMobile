import 'package:flutter/material.dart';
import '../models/notification.dart';
import '../services/api_service.dart';

class NotificationProvider extends ChangeNotifier {
  List<AppNotification> _notifications = [];
  bool _loading = false;
  String? _error;
  final ApiService _apiService = ApiService();

  List<AppNotification> get notifications => _notifications;
  bool get loading => _loading;
  String? get error => _error;

  Future<void> fetchNotifications() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final response = await _apiService.get('/api/notifications');
      _notifications = (response.data as List)
          .map((json) => AppNotification.fromJson(json))
          .toList();
    } catch (e) {
      _error = e.toString();
    }
    _loading = false;
    notifyListeners();
  }

  Future<void> markAllAsRead() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      await _apiService.put('/api/notifications/mark-all-read');
      await fetchNotifications();
    } catch (e) {
      _error = e.toString();
    }
    _loading = false;
    notifyListeners();
  }

  Future<void> markAsRead(int id) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      await _apiService.put('/api/notifications/$id/mark-read');
      await fetchNotifications();
    } catch (e) {
      _error = e.toString();
    }
    _loading = false;
    notifyListeners();
  }

  Future<void> deleteNotification(int id) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      await _apiService.delete('/api/notifications/$id');
      await fetchNotifications();
    } catch (e) {
      _error = e.toString();
    }
    _loading = false;
    notifyListeners();
  }
} 