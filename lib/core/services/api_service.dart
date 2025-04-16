import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://localhost:8082/api', 
     
    ),
  );

  ApiService() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // Add headers or tokens here
        options.headers['Content-Type'] = 'application/json';
        return handler.next(options);
      },
      onResponse: (response, handler) {
        // Handle successful responses
        return handler.next(response);
      },
      onError: (DioError e, handler) {
        // Handle errors globally
        return handler.next(e);
      },
    ));
  }

  Future<Response> post(String endpoint, dynamic data) async {
    try {
      return await _dio.post(endpoint, data: data);
    } catch (e) {
      rethrow;
    }
  }
}