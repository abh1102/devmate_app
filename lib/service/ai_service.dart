
import 'dart:convert';


import 'package:dio/dio.dart';

class ChatService {
  static const String baseUrl = 'http://192.168.1.235:8081';

  late final Dio _dio;

  ChatService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 90),
        sendTimeout: const Duration(seconds: 15),
        headers: {
          'Accept': 'application/json',
        },
      ),
    );
  }

  Future<String> sendMessage(String prompt) async {
    try {
      final response = await _dio.get(
        '/api/ai/chat',
        queryParameters: {
          'prompt': prompt,
        },
      );

      final data = response.data;

      if (data is! Map<String, dynamic>) {
        throw Exception('Invalid API response format.');
      }

      final answer = data['response'];

      if (answer == null || answer.toString().trim().isEmpty) {
        throw Exception('The AI returned an empty response.');
      }

      return answer.toString();
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception('Connection timed out. Check your backend.');
      }

      if (e.type == DioExceptionType.receiveTimeout) {
        throw Exception('The AI took too long to respond.');
      }

      if (e.type == DioExceptionType.connectionError) {
        throw Exception(
          'Could not connect to DevMate API. '
              'Check the server and base URL.',
        );
      }

      final statusCode = e.response?.statusCode;
      final body = e.response?.data;

      throw Exception(
        'API error ${statusCode ?? "unknown"}: $body',
      );
    }
  }
}
