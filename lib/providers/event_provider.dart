import 'package:flutter/material.dart';
import '../models/event.dart';
import '../services/api_service.dart';

class EventProvider extends ChangeNotifier {
  List<Event> _events = [];
  bool _loading = false;
  String? _error;
  final ApiService _apiService = ApiService();

  List<Event> get events => _events;
  bool get loading => _loading;
  String? get error => _error;

  Future<void> fetchEvents() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final response = await _apiService.get('/api/events');
      _events = (response.data as List)
          .map((json) => Event.fromJson(json))
          .toList();
    } catch (e) {
      _error = e.toString();
    }
    _loading = false;
    notifyListeners();
  }

  Future<void> addEvent(Map<String, dynamic> eventData) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      await _apiService.post('/api/events', data: eventData);
      await fetchEvents();
    } catch (e) {
      _error = e.toString();
    }
    _loading = false;
    notifyListeners();
  }

  Future<void> editEvent(int id, Map<String, dynamic> eventData) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      await _apiService.put('/api/events/$id', data: eventData);
      await fetchEvents();
    } catch (e) {
      _error = e.toString();
    }
    _loading = false;
    notifyListeners();
  }

  Future<void> deleteEvent(int id) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      await _apiService.delete('/api/events/$id');
      await fetchEvents();
    } catch (e) {
      _error = e.toString();
    }
    _loading = false;
    notifyListeners();
  }
} 