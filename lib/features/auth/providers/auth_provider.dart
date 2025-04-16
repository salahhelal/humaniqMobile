import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  String? _token;
  bool _isAuthenticated = false;

  String? get token => _token;
  bool get isAuthenticated => _isAuthenticated;

  /// Load Token from Secure Storage
  Future<void> loadToken() async {
    final savedToken = await AuthService.getToken();
    if (savedToken != null && !JwtDecoder.isExpired(savedToken)) {
      _token = savedToken;
      _isAuthenticated = true;
    } else {
      logout(); // Clear invalid/expired token
    }
    notifyListeners();
  }

  /// Login
  Future<bool> login(String username, String password) async {
    try {
      final token = await AuthService.login(username, password);
      if (token != null && !JwtDecoder.isExpired(token)) {
        _token = token;
        _isAuthenticated = true;

        await AuthService.saveToken(token); // Save token securely

        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Register
  Future<bool> register(Map<String, dynamic> registerData) async {
    try {
      final success = await AuthService.register(registerData);
      return success;
    } catch (e) {
      return false;
    }
  }

  /// Logout
  void logout() async {
    _token = null;
    _isAuthenticated = false;

    await AuthService.removeToken(); // Remove token securely

    notifyListeners();
  }
}