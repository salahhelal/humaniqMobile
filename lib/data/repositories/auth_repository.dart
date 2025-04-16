import 'package:humaniq/core/services/api_service.dart';
import 'package:humaniq/data/models/auth_request.dart';
import 'package:humaniq/data/models/login_response.dart';


class AuthRepository {
  final ApiService _apiService;

  AuthRepository(this._apiService);

  Future<LoginResponse> login(AuthRequest request) async {
    final response = await _apiService.post('/auth/login', request.toJson());
    return LoginResponse.fromJson(response.data);
  }

  Future<String> register(AuthRequest request) async {
    final response = await _apiService.post('/auth/register', request.toJson());
    return response.data['message'];
  }
}