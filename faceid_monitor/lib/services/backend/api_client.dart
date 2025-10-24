import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Cliente HTTP usando Dio
/// TODO: Configurar baseUrl quando backend estiver disponível
class ApiClient {
  late final Dio _dio;
  
  static const String _baseUrl = 'https://api.citylabsecurity.com'; // TODO: Ajustar URL
  
  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
    
    _setupInterceptors();
  }
  
  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // TODO: Adicionar token de autenticação
          // options.headers['Authorization'] = 'Bearer $token';
          
          if (kDebugMode) {
            debugPrint('🌐 REQUEST[${options.method}] => ${options.path}');
          }
          
          return handler.next(options);
        },
        onResponse: (response, handler) {
          if (kDebugMode) {
            debugPrint('✅ RESPONSE[${response.statusCode}] => ${response.requestOptions.path}');
          }
          
          return handler.next(response);
        },
        onError: (error, handler) {
          if (kDebugMode) {
            debugPrint('❌ ERROR[${error.response?.statusCode}] => ${error.requestOptions.path}');
            debugPrint('Message: ${error.message}');
          }
          
          return handler.next(error);
        },
      ),
    );
  }
  
  Dio get dio => _dio;
  
  // Métodos auxiliares
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _dio.get<T>(
      path,
      queryParameters: queryParameters,
      options: options,
    );
  }
  
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _dio.post<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }
  
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _dio.put<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }
  
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _dio.delete<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }
}

/// Provider global do ApiClient
final apiClient = ApiClient();
