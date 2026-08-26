import 'package:dio/dio.dart';
import '../config.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  late final Dio _dio;

  factory ApiClient() {
    return _instance;
  }

  ApiClient._internal() {
    _dio = Dio(BaseOptions(
      baseUrl: AppConfig.fastapiBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
      },
    ));
    
    // Add logging interceptor for debugging
    _dio.interceptors.add(LogInterceptor(
      request: true,
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
      error: true,
    ));
  }

  Dio get client => _dio;

  // Example method to manually trigger AI analysis via FastAPI
  Future<Map<String, dynamic>> triggerAnalysis(String deviceId) async {
    try {
      final response = await _dio.post('/sensor/analyze/$deviceId');
      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to trigger analysis: $e');
    }
  }

  // Example method to resolve an alert via FastAPI
  Future<bool> resolveAlert(String alertId) async {
    try {
      final response = await _dio.post('/sensor/alerts/$alertId/resolve');
      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Failed to resolve alert: $e');
    }
  }
}
