import 'package:flutter/material.dart';
import '../models/chat_room.dart';
import '../models/message.dart';
import '../services/api_service.dart';

class ChatProvider extends ChangeNotifier {
  List<ChatRoom> _chatRooms = [];
  List<Message> _messages = [];
  bool _loading = false;
  String? _error;
  final ApiService _apiService = ApiService();

  List<ChatRoom> get chatRooms => _chatRooms;
  List<Message> get messages => _messages;
  bool get loading => _loading;
  String? get error => _error;

  Future<void> fetchChatRooms(int userId) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final response = await _apiService.get('/api/chatroom/$userId/rooms');
      _chatRooms = (response.data as List)
          .map((json) => ChatRoom.fromJson(json))
          .toList();
    } catch (e) {
      _error = e.toString();
    }
    _loading = false;
    notifyListeners();
  }

  Future<void> fetchMessages(int chatRoomId) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final response = await _apiService.get('/api/chatroom/$chatRoomId/messages');
      _messages = (response.data as List)
          .map((json) => Message.fromJson(json))
          .toList();
    } catch (e) {
      _error = e.toString();
    }
    _loading = false;
    notifyListeners();
  }
} 