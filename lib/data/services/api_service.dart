// lib/data/services/api_service.dart
import 'package:dio/dio.dart';

import '../models/category_model.dart';
import '../../core/constants/app_constants.dart';

class ApiService {
  final Dio _dio;

  ApiService(this._dio) {
    _dio.options.baseUrl = AppConstants.apiUrl;
    _dio.options.connectTimeout = const Duration(seconds: 5);
    _dio.options.receiveTimeout = const Duration(seconds: 5);
  }

  Future<List<CategoryModel>> fetchCategories() async {
    try {
      final response = await _dio.get('');
      if (response.statusCode == 200) {
        final data = response.data['record']['categories'] as List<dynamic>;
        return data.map((json) => CategoryModel.fromJson(json)).toList();
      } else {
        throw ApiException('Failed to load categories: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw ApiException('Request timed out');
      } else if (e.response != null) {
        throw ApiException('Error: ${e.response?.statusCode} - ${e.message}');
      } else {
        throw ApiException('Network error: ${e.message}');
      }
    } catch (e) {
      throw ApiException('Unexpected error: $e');
    }
  }
}

class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => message;
}
