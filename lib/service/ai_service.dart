
import 'package:dio/dio.dart';

class AiService {
  AiService()
      : _dio = Dio(
    BaseOptions(
      baseUrl: 'http://localhost:8081',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(minutes: 3),
    ),
  );

  final Dio _dio;

  Future<String> sendMessage(String prompt) async {
    try {
      final response = await _dio.get(
        '/api/ai/chat',
        queryParameters: {'prompt': prompt},
      );

      final data = response.data;

      if (data is Map && data['response'] is String) {
        return (data['response'] as String).trim();
      }

      throw Exception('Unexpected response from DevMate API.');
    } on DioException catch (e) {
      final data = e.response?.data;
      final message = data is Map
          ? data['detail'] ?? data['message'] ?? data['error']
          : null;

      throw Exception(
        message?.toString() ??
            'Could not connect to DevMate AI. Check the backend.',
      );
    }
  }
}
